/**
 * @file stimud-gpio.c
 * @author Daniel Starke
 * @copyright Copyright 2020 Daniel Starke
 * @date 2020-04-01
 * @version 2020-04-11
 * 
 * @remarks This code is Allwinner V3s specific.
 */
#include <errno.h>
#include <fcntl.h>
#include <stdlib.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>
#include <sys/mman.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>


/* Defines the memory regions for the GPIO port registers. Code changes are necessary if these
 * values are changed. */
#define GPIO_PORT_BASE 0x01C20800UL
#define GPIO_PORT_SIZE 0x24
#define GPIO_PORT_COUNT 7
#define GPIO_PORT_NUMS 32 /* same as in Linux for compatibility */


/** Defines the file descriptor for standard outputs.  */
#define FOUT stdout


/**
 * @def likely(x) 
 * Optimizes branch prediction for the case that the expression evaluates to true.
 * @def unlikely(x) 
 * Optimizes branch prediction for the case that the expression evaluates to false.
 * @def unreachable()
 * Let the compiler assume that this code path cannot be taken.
 */
#if defined(__GNUC__) || defined(__clang__)
#define likely(x) __builtin_expect(!!(x), 1)
#define unlikely(x) __builtin_expect(!!(x), 0)
#define unreachable() __builtin_unreachable()
#else
#define likely(x) (x)
#define unlikely(x) (x)
#define unreachable()
#endif


/**
 * Describes the port controller registers of a single port.
 */
typedef struct {
	uint32_t CFG[4];
	uint32_t DAT;
	uint32_t DRV[2];
	uint32_t PUL[2];
} tGpioPort;


/**
 * Prints description for a register.
 */
typedef struct {
	const char * key;
	uint32_t reg;
	size_t offset;
	size_t size;
	void (*printer)(FILE * fd, const uint32_t val, const char * user);
	const char * user;
} tPrintDesc;


/**
 * Number of available IOs per GPIO port.
 */
static const size_t ioCount[] = {
	0, 10, 4, 0, 25, 7, 6
};


/**
 * List of available functions per IO pin.
 * 
 * @remarks See Allwinner V3s Datasheet v1.0 chapter 3.2.
 */
static const char * ioFn[] = {
	/* PA */
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	/* PB */
	"UART2_TX\0\0\0\0PB_EINT0",
	"UART2_RX\0\0\0\0PB_EINT1",
	"UART2_RTS\0\0\0\0PB_EINT2",
	"UART2_CTS\0\0\0\0PB_EINT3",
	"PWM0\0\0\0\0PB_EINT4",
	"PWM1\0\0\0\0PB_EINT5",
	"TWI0_SCK\0\0\0\0PB_EINT6",
	"TWI0_SDA\0\0\0\0PB_EINT7",
	"TWI1_SCK\0UART0_TX\0\0\0PB_EINT8",
	"TWI1_SDA\0UART0_RX\0\0\0PB_EINT8",
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	/* PC */
	"SDC2_CLK\0SPI0_MISO\0\0\0",
	"SDC2_CMD\0SPI0_CLK\0\0\0",
	"SDC2_RST\0SPI0_CS\0\0\0",
	"SDC2_D0\0SPI0_MOSI\0\0\0",
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	/* PD */
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	/* PE */
	"CSI_PCLK\0LCD_CLK\0\0\0",
	"CSI_MCLK\0LCD_DE\0\0\0",
	"CSI_HSYNC\0LCD_HSYNC\0\0\0",
	"CSI_VSYNC\0LCD_VSYNC\0\0\0",
	"CSI_D0\0LCD_D2\0\0\0",
	"CSI_D1\0LCD_D3\0\0\0",
	"CSI_D2\0LCD_D4\0\0\0",
	"CSI_D3\0LCD_D5\0\0\0",
	"CSI_D4\0LCD_D6\0\0\0",
	"CSI_D5\0LCD_D7\0\0\0",
	"CSI_D6\0LCD_D10\0\0\0",
	"CSI_D7\0LCD_D11\0\0\0",
	"CSI_D8\0LCD_D12\0\0\0",
	"CSI_D9\0LCD_D13\0\0\0",
	"CSI_D10\0LCD_D14\0\0\0",
	"CSI_D11\0LCD_D15\0\0\0",
	"CSI_D12\0LCD_D18\0\0\0",
	"CSI_D13\0LCD_D19\0\0\0",
	"CSI_D14\0LCD_D20\0\0\0",
	"CSI_D15\0LCD_D21\0\0\0",
	"CSI_FIELD\0CSI_MIPI_MCLK\0\0\0",
	"CSI_SCK\0TWI1_SCK\0UART1_TX\0\0",
	"CSI_SDA\0TWI1_SDA\0UART1_RX\0\0",
	"\0LCD_D22\0UART1_RTS\0\0",
	"\0LCD_D23\0UART1_CTS\0\0",
	NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	/* PF */
	"SDC0_D1\0JTAG_MS\0\0\0",
	"SDC0_D0\0JTAG_DI\0\0\0",
	"SDC0_CLK\0UART0_TX\0\0\0",
	"SDC0_CMD\0JTAG_DO\0\0\0",
	"SDC0_D3\0UART0_RX\0\0\0",
	"SDC0_D2\0JTAG_CK\0\0\0",
	"\0\0\0\0",
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL,
	/* PG */
	"SDC1_CLK\0\0\0\0PG_EINT0",
	"SDC1_CMD\0\0\0\0PG_EINT1",
	"SDC1_D0\0\0\0\0PG_EINT2",
	"SDC1_D1\0\0\0\0PG_EINT3",
	"SDC1_D2\0\0\0\0PG_EINT4",
	"SDC1_D3\0\0\0\0PG_EINT5",
	NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
};


/**
 * Checks if the given pin number is valid.
 * 
 * @param[in] pin - pin to check
 * @return 1 if the pin was valid, else 0
 */
static int isValidPin(const size_t pin) {
	const size_t port = pin / GPIO_PORT_NUMS;
	if (unlikely(port >= GPIO_PORT_COUNT)) return 0;
	const size_t num = pin % GPIO_PORT_NUMS;
	if (num >= ioCount[port]) return 0;
	return 1;
}


/**
 * Returns the bits starting at the given address, bit offset and
 * with the passed number of bits.
 * 
 * @param[in] addr - pointer to the register
 * @param[in] offset - bit offset within the register
 * @param[in] size - number of bits
 * @return extracted bits
 */
static uint32_t getBits(const volatile uint32_t * addr, size_t offset, size_t size) {
	if (addr == NULL) unreachable();
	if (unlikely(size == 32)) return *addr;
	const uint32_t mask = UINT32_MAX >> (32 - size);
	return (*addr >> offset) & mask;
}


/**
 * Sets the passed bits value at the given address, bit offset and
 * with the number of bits given.
 * 
 * @param[in,out] addr - pointer to the register
 * @param[in] offset - bit offset within the register
 * @param[in] size - number of bits
 * @param[in] val - value to set
 * @remarks val shall not exceed the bit size give or the behavior is undefined.
 */
static void setBits(volatile uint32_t * addr, size_t offset, size_t size, uint32_t val) {
	if (addr == NULL) unreachable();
	if (unlikely(size == 32)) {
		*addr = val;
	} else {
		val <<= offset;
		const uint32_t mask = ~((UINT32_MAX >> (32 - size)) << offset);
		*addr &= mask; /* clear bits */
		*addr |= val; /* set bits */
	}
}


/**
 * Prints the given registers as described to the passed file descriptor.
 * 
 * @param[in,out] fd - output file descriptor
 * @param[in] desc - registers and print description array
 */
static void printRegisters(FILE * fd, const tPrintDesc * desc) {
	const char * fmt[] = {
		"%s = %u 0x%02X b",
		"%s = %u 0x%04X b",
		"%s = %u 0x%06X b",
		"%s = %u 0x%08X b"
	};
	if (fd == NULL || desc == NULL) unreachable();
	for (; desc->key != NULL; desc++) {
		const uint32_t val = getBits(&(desc->reg), desc->offset, desc->size);
		/* print dec, hex */
		fprintf(fd, fmt[desc->size >> 8], desc->key, (unsigned)val, (unsigned)val);
		/* print bin */
		if (desc->size < 1 || desc->size > 32) unreachable();
		uint32_t mask = (uint32_t)1 << (desc->size - 1);
		for (size_t n = 0; n < desc->size; n++, mask >>= 1) {
			fputc((val & mask) != 0 ? '1' : '0', fd);
		}
		/* print mapping */
		if (desc->printer != NULL) {
			fputc(' ', fd);
			(*(desc->printer))(fd, val, desc->user);
		}
		fputc('\n', fd);
	}
}


/**
 * Prints the configuration register pin state.
 * 
 * @param[in] fd - output file descriptor
 * @param[in] val - value of the pin
 * @param[in] user - 0 terminated list of pin functions
 */
static void printCfg(FILE * fd, const uint32_t val, const char * user) {
	const char * fn[8] = {
		"Input", "Output", NULL, NULL, NULL, NULL, NULL, "IO Disabled"
	};
	if (fd == NULL || user == NULL) unreachable();
	for (size_t n = 0; n < 5; n++, user += strlen(user) + 1) {
		fn[n + 2] = (*user == 0) ? "Reserved" : user;
	}
	if (likely(val < 8)) {
		fprintf(fd, "<%s>", fn[val]);
	} else {
		fprintf(fd, "<INVALID>");
	}
}


/**
 * Prints the multi-driving register pin state.
 * 
 * @param[in] fd - output file descriptor
 * @param[in] val - value of the pin
 * @param[in] user - unused
 */
static void printDrv(FILE * fd, const uint32_t val, const char * user) {
	(void)user;
	if (fd == NULL) unreachable();
	if (likely(val < 4)) {
		fprintf(fd, "<Level %u>", (unsigned)val);
	} else {
		fprintf(fd, "<INVALID>");
	}
}


/**
 * Prints the pull register pin state.
 * 
 * @param[in] fd - output file descriptor
 * @param[in] val - value of the pin
 * @param[in] user - unused
 */
static void printPul(FILE * fd, const uint32_t val, const char * user) {
	static const char * str[] = {
		"Pull-up/down disabled",
		"Pull-up",
		"Pull-down",
		"Reserved"
	};
	(void)user;
	if (fd == NULL) unreachable();
	if (likely(val < 4)) {
		fprintf(fd, "<%s>", str[val]);
	} else {
		fprintf(fd, "<INVALID>");
	}
}


/**
 * Prints a short description to standard error on how to use this
 * command-line tool.
 */
static void printHelp(void) {
	fprintf(stderr,
		"stimud-gpio <action> [<modes>] [<pin#> ...]\n"
		"\n"
		"possible actions:\n"
		"c - clears the output pins\n"
		"f - prints all possible functions of the pins\n"
		"g - returns the value of the input pins\n"
		"h - prints this help\n"
		"m - sets the mode of the pins (see modes below)\n"
		"l - lists the values and configuration the given or all pins\n"
		"s - set the output pins\n"
		"\n"
		"possible modes (multiple possible):\n"
		"- - disabled\n"
		"i - input\n"
		"o - output\n"
		"f - floating\n"
		"u - pull-up\n"
		"d - pull-down\n"
		"\n"
		"pin# can be any number starting at %i for PB0.\n",
		GPIO_PORT_NUMS
	);
}


/**
 * Applies the given action for the passed pin.
 * 
 * @param[in] ptr - GPIO register pointer
 * @param[in] action - action to apply
 * @param[in] modes - action modes if any
 * @param[in] pin - pin number
 */
static void applyAction(volatile tGpioPort * ptr, const char action, const char * modes, const size_t pin) {
	const size_t port = pin / GPIO_PORT_NUMS;
	const size_t num = pin % GPIO_PORT_NUMS;
	const size_t cfgIdx = num / 8;
	const size_t cfgNum = num - (cfgIdx * 8);
	const size_t drvIdx = num / 16;
	const size_t drvNum = num - (drvIdx * 16);
	const size_t pulIdx = num / 16;
	const size_t pulNum = num - (pulIdx * 16);
	if (ptr == NULL) unreachable();
	switch (action) {
	case 'c':
		/* set output value 0 */
		setBits(&(ptr[port].DAT), num, 1, 0);
		break;
	case 'f':
		/* print pin possible functions */
		fprintf(FOUT, "# PIN %u (P%c%u)\n", (unsigned)pin, (int)('A' + port), (unsigned)num);
		for (uint32_t n = 0; n < 8; n++) {
			fprintf(FOUT, "%u: ", (unsigned)n);
			printCfg(FOUT, n, ioFn[pin]);
			fputc('\n', FOUT);
		}
		break;
	case 'g':
		/* print input value (0 or 1) */
		fprintf(FOUT, "%c\n", '0' + getBits(&(ptr[port].DAT), num, 1));
		break;
	case 'm':
		/* change pin mode */
		for (const char * ch = modes; *ch != 0; ch++) {
			switch (*ch) {
			case '-':
				setBits(ptr[port].CFG + cfgIdx, cfgNum * 4, 3, 0x3); /* disable IO */
				break;
			case 'i':
				setBits(ptr[port].CFG + cfgIdx, cfgNum * 4, 3, 0x0); /* set to input mode */
				break;
			case 'o':
				setBits(ptr[port].CFG + cfgIdx, cfgNum * 4, 3, 0x1); /* set to output mode */
				break;
			case 'f':
				setBits(ptr[port].PUL + pulIdx, pulNum * 2, 2, 0x0); /* set floating */
				break;
			case 'u':
				setBits(ptr[port].PUL + pulIdx, pulNum * 2, 2, 0x1); /* enable pull-up */
				break;
			case 'd':
				setBits(ptr[port].PUL + pulIdx, pulNum * 2, 2, 0x2); /* enable pull-down */
				break;
			default:
				continue;
			}
		}
		break;
	case 'l':
		/* list pin value and configuration */
		fprintf(FOUT, "# PIN %u (P%c%u)\n", (unsigned)pin, (int)('A' + port), (unsigned)num);
		printRegisters(FOUT, (const tPrintDesc[]){
			{"CFG", ptr[port].CFG[cfgIdx], cfgNum * 4, 3, printCfg, ioFn[pin]},
			{"DAT", ptr[port].DAT, num, 1, NULL, NULL},
			{"DRV", ptr[port].DRV[drvIdx], drvNum * 2, 2, printDrv, NULL},
			{"PUL", ptr[port].PUL[pulIdx], pulNum * 2, 2, printPul, NULL},
			{NULL}
		});
		break;
	case 's':
		/* set output value 1 */
		setBits(&(ptr[port].DAT), num, 1, 1);
		break;
	default:
		unreachable();
		break;
	}
}


/**
 * Main entry point.
 * 
 * @param[in] argc - number of command-line arguments given 
 * @param[in,out] args - array of given command-line arguments
 * @return exit code
 */
int main(int argc, char ** args) {
	if (unlikely(argc < 2 || args[1][0] == 0 || args[1][1] != 0 || args[1][0] == 'h' || strchr("cfghmls", args[1][0]) == NULL)) {
		printHelp();
		return EXIT_FAILURE;
	}
	
	const char action = args[1][0];
	const char * modes = (action == 'm') ? args[2] : NULL;
	int pinIdx = (action == 'm') ? 3 : 2;
	const size_t pageSize = sysconf(_SC_PAGESIZE);
	const int fd = open("/dev/mem" , O_RDWR | O_SYNC);
	void * mappedAddr = NULL;
	volatile tGpioPort * gpio = NULL;
	int res = EXIT_FAILURE;
	
	size_t pages = 1;
	while ((pages * pageSize) < ((GPIO_PORT_BASE & (pageSize - 1)) + (GPIO_PORT_SIZE * GPIO_PORT_COUNT))) pages++;
	
	/* open memory */
	if (unlikely(fd < 0)) {
		fprintf(stderr, "Error: Failed to open /dev/mem. %s.\n", strerror(errno));
		goto onError;
	}
	
	/* map physical memory region of GPIO registers into user space */
	do {
		errno = 0;
		/* note: we can only request memory pages here (i.e. aligned to and a multiple of it) */
		mappedAddr = mmap(NULL, pages * pageSize, PROT_READ | PROT_WRITE, MAP_SHARED, fd, GPIO_PORT_BASE & ~(pageSize - 1));
	} while (unlikely(mappedAddr == MAP_FAILED && errno == EAGAIN));
	if (unlikely(mappedAddr == MAP_FAILED)) {
		fprintf(stderr, "Error: Failed to map GPIO memory region into user space. %s.\n", strerror(errno));
		goto onError;
	}
	gpio = (volatile tGpioPort *)((uint8_t *)mappedAddr + (GPIO_PORT_BASE & (pageSize - 1)));
	
	/* check conflicting modes */
	if (action == 'm') {
		enum {M_IO = 1, M_PULL = 2};
		int mSet = 0;
		for (const char * ch = modes; *ch != 0; ch++) {
			int m = 0;
			switch (*ch) {
			case '-':
				m = M_IO | M_PULL;
				break;
			case 'i':
			case 'o':
				m = M_IO;
				break;
			case 'f':
			case 'u':
			case 'd':
				m = M_PULL;
				break;
			default:
				fprintf(stderr, "Warning: Ignoring invalid mode '%c'.\n", *ch);
				continue;
			}
			if (unlikely((mSet & m) != 0)) {
				fprintf(stderr, "Error: Mode '%c' conflicts with another mode.\n", *ch);
				goto onError;
			}
			mSet |= m;
		}
		if (unlikely(mSet == 0)) goto onSuccess; /* nothing to set */
	}
	
	/* apply action */
	if (unlikely(argc == 2 && action == 'l')) {
		/* list the values and configuration of all pins */
		for (size_t pin = 0; pin < (GPIO_PORT_COUNT * GPIO_PORT_NUMS); pin++) {
			if (isValidPin(pin) == 0) continue;
			applyAction(gpio, action, modes, pin);
		}
	} else {
		/* apply action for each given pin */
		char * endPtr;
		size_t pin;
		for (; pinIdx < argc; pinIdx++) {
			if (args[pinIdx][0] == 'P' && args[pinIdx][1] >= 'A' && args[pinIdx][1] < ('A' + GPIO_PORT_COUNT)) {
				/* parse pin given like PG1 */
				const size_t port = (size_t)(args[pinIdx][1] - 'A');
				const size_t num = (size_t)strtoul(args[pinIdx] + 2, &endPtr, 10);
				pin = (port * GPIO_PORT_NUMS) + num;
				if (unlikely(endPtr == NULL || *endPtr != 0 || isValidPin(pin) == 0)) {
					fprintf(stderr, "Warning: Ignoring invalid pin number %s.\n", args[pinIdx]);
					continue;
				}
			} else {
				/* parse pin given as number */
				pin = (size_t)strtoul(args[pinIdx], &endPtr, 10);
				if (unlikely(endPtr == NULL || *endPtr != 0 || isValidPin(pin) == 0)) {
					fprintf(stderr, "Warning: Ignoring invalid pin number %s.\n", args[pinIdx]);
					continue;
				}
			}
			applyAction(gpio, action, modes, pin);
		}
	}
	
onSuccess:
	res = EXIT_SUCCESS;
onError:
	/* close open handles */
	if (likely(mappedAddr != NULL)) munmap(mappedAddr, pages * pageSize);
	if (likely(fd >= 0)) close(fd);
	return res;
}
