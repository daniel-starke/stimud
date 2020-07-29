EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title ""
Date ""
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L MCU_Module:Lichee_Pi_Zero A1
U 1 1 5E963ECD
P 5000 4800
F 0 "A1" H 3400 6550 50  0000 L CNN
F 1 "Lichee_Pi_Zero" H 3400 6450 50  0000 L CNN
F 2 "Module:Lichee_Pi_Zero" H 3900 3350 50  0001 C CIN
F 3 "https://github.com/Lichee-Pi/Lichee-Zero-Doc-us-english" H 3800 5520 50  0001 C CNN
	1    5000 4800
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Coded_SH-7050 SW1
U 1 1 5E975806
P 1600 3600
F 0 "SW1" H 1657 4067 50  0000 C CNN
F 1 "SW_Coded_RV4HAF-16R-V-B" H 1657 3976 50  0000 C CNN
F 2 "Button_Switch_THT:SW_TH_SC1111" H 1300 3150 50  0001 L CNN
F 3 "https://www.mouser.com/datasheet/2/910/420_RH-1571332.pdf" H 1600 3600 50  0001 C CNN
	1    1600 3600
	1    0    0    -1  
$EndComp
Wire Wire Line
	2000 3400 3300 3400
Wire Wire Line
	3300 3600 2900 3600
Wire Wire Line
	2900 3600 2900 3500
Wire Wire Line
	2900 3500 2000 3500
Wire Wire Line
	3300 3800 2700 3800
Wire Wire Line
	2700 3800 2700 3600
Wire Wire Line
	2700 3600 2000 3600
Wire Wire Line
	3300 4000 2500 4000
Wire Wire Line
	2500 4000 2500 3700
Wire Wire Line
	2500 3700 2000 3700
Wire Wire Line
	3300 4200 2300 4200
Wire Wire Line
	2300 4200 2300 3800
Wire Wire Line
	2300 3800 2000 3800
$Comp
L power:GND #PWR0101
U 1 1 5E97A17A
P 5000 6300
F 0 "#PWR0101" H 5000 6050 50  0001 C CNN
F 1 "GND" H 5005 6127 50  0000 C CNN
F 2 "" H 5000 6300 50  0001 C CNN
F 3 "" H 5000 6300 50  0001 C CNN
	1    5000 6300
	1    0    0    -1  
$EndComp
NoConn ~ 5150 3100
NoConn ~ 5050 3100
NoConn ~ 4950 3100
$Comp
L power:+5V #PWR0102
U 1 1 5E97CC5C
P 4750 3100
F 0 "#PWR0102" H 4750 2950 50  0001 C CNN
F 1 "+5V" H 4765 3273 50  0000 C CNN
F 2 "" H 4750 3100 50  0001 C CNN
F 3 "" H 4750 3100 50  0001 C CNN
	1    4750 3100
	1    0    0    -1  
$EndComp
NoConn ~ 3300 3500
NoConn ~ 3300 3700
NoConn ~ 3300 3900
NoConn ~ 3300 4100
$Comp
L Connector_Generic:Conn_01x03 J1
U 1 1 5E97DBD0
P 1700 4900
F 0 "J1" H 1618 4575 50  0000 C CNN
F 1 "Conn_01x03" H 1618 4666 50  0000 C CNN
F 2 "Connector_PinHeader_2.54mm:PinHeader_1x03_P2.54mm_Vertical" H 1700 4900 50  0001 C CNN
F 3 "~" H 1700 4900 50  0001 C CNN
	1    1700 4900
	-1   0    0    1   
$EndComp
Wire Wire Line
	3300 4800 1900 4800
Wire Wire Line
	3300 5000 2450 5000
Wire Wire Line
	2450 5000 2450 4900
Wire Wire Line
	2450 4900 1900 4900
Wire Wire Line
	1900 5000 2050 5000
Wire Wire Line
	2050 5000 2050 5250
$Comp
L power:GND #PWR0104
U 1 1 5E97F65D
P 2050 5500
F 0 "#PWR0104" H 2050 5250 50  0001 C CNN
F 1 "GND" H 2055 5327 50  0000 C CNN
F 2 "" H 2050 5500 50  0001 C CNN
F 3 "" H 2050 5500 50  0001 C CNN
	1    2050 5500
	1    0    0    -1  
$EndComp
NoConn ~ 3300 4400
NoConn ~ 3300 4500
NoConn ~ 3300 4600
NoConn ~ 3300 4700
NoConn ~ 3300 4900
NoConn ~ 3300 5100
NoConn ~ 3300 5200
NoConn ~ 3300 5300
NoConn ~ 3300 5400
NoConn ~ 3300 5500
NoConn ~ 3300 5600
NoConn ~ 3300 5700
NoConn ~ 3300 5800
Wire Wire Line
	6300 5100 7550 5100
Wire Wire Line
	7550 5100 7550 2500
$Comp
L power:GND #PWR0105
U 1 1 5E9861E8
P 8250 950
F 0 "#PWR0105" H 8250 700 50  0001 C CNN
F 1 "GND" H 8255 777 50  0000 C CNN
F 2 "" H 8250 950 50  0001 C CNN
F 3 "" H 8250 950 50  0001 C CNN
	1    8250 950 
	1    0    0    -1  
$EndComp
Wire Wire Line
	8250 950  8250 800 
Wire Wire Line
	8250 800  8100 800 
Wire Wire Line
	7900 800  7750 800 
$Comp
L Connector:Micro_SD_Card_Det_1 J2
U 1 1 5E99B53B
P 7250 1600
F 0 "J2" V 8200 2200 50  0000 R CNN
F 1 "Micro_SD_Card_Det_1" V 8100 2200 50  0000 R CNN
F 2 "Connector_Card:microSD_TF-01A" H 9300 2300 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/1903221101_Korean-Hroparts-Elec-TF-01A_C91145.pdf" H 7250 1700 50  0001 C CNN
	1    7250 1600
	0    -1   -1   0   
$EndComp
Wire Wire Line
	6300 5300 7450 5300
Wire Wire Line
	7450 5300 7450 2500
Wire Wire Line
	6850 2500 6850 6000
Wire Wire Line
	6850 6000 6300 6000
Wire Wire Line
	6950 2500 6950 5900
Wire Wire Line
	6950 5900 6300 5900
Wire Wire Line
	7050 2500 7050 5700
Wire Wire Line
	7050 5700 6300 5700
Wire Wire Line
	7250 2500 7250 5500
Wire Wire Line
	7250 5500 6300 5500
$Comp
L power:GND #PWR0106
U 1 1 5E99F381
P 7350 2950
F 0 "#PWR0106" H 7350 2700 50  0001 C CNN
F 1 "GND" H 7355 2777 50  0000 C CNN
F 2 "" H 7350 2950 50  0001 C CNN
F 3 "" H 7350 2950 50  0001 C CNN
	1    7350 2950
	1    0    0    -1  
$EndComp
Wire Wire Line
	7150 2500 7150 2550
$Comp
L Connector:USB_A J3
U 1 1 5E9A2C7E
P 9500 4700
F 0 "J3" H 9700 5150 50  0000 R CNN
F 1 "USB_A" H 9700 5050 50  0000 R CNN
F 2 "Connector_USB:USB_A_TH_AM90" H 9650 4650 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/1811131825_Jing-Extension-of-the-Electronic-Co-C9739_C9739.pdf" H 9650 4650 50  0001 C CNN
	1    9500 4700
	-1   0    0    -1  
$EndComp
Wire Wire Line
	7650 2500 7650 2850
Wire Wire Line
	7650 2850 3050 2850
Wire Wire Line
	3050 2850 3050 4300
Wire Wire Line
	3050 4300 3300 4300
$Comp
L Device:C_Small C3
U 1 1 5E9A5EA6
P 9600 5300
F 0 "C3" H 9508 5254 50  0000 R CNN
F 1 "100n" H 9508 5345 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 9600 5300 50  0001 C CNN
F 3 "~" H 9600 5300 50  0001 C CNN
	1    9600 5300
	-1   0    0    1   
$EndComp
Wire Wire Line
	9500 5100 9500 5500
$Comp
L power:GND #PWR0108
U 1 1 5E9AAED8
P 9950 5500
F 0 "#PWR0108" H 9950 5250 50  0001 C CNN
F 1 "GND" H 9955 5327 50  0000 C CNN
F 2 "" H 9950 5500 50  0001 C CNN
F 3 "" H 9950 5500 50  0001 C CNN
	1    9950 5500
	1    0    0    -1  
$EndComp
$Comp
L power:+5V #PWR0109
U 1 1 5E9AC6A0
P 9100 2550
F 0 "#PWR0109" H 9100 2400 50  0001 C CNN
F 1 "+5V" H 9115 2723 50  0000 C CNN
F 2 "" H 9100 2550 50  0001 C CNN
F 3 "" H 9100 2550 50  0001 C CNN
	1    9100 2550
	1    0    0    -1  
$EndComp
$Comp
L Device:R_Small R1
U 1 1 5E9ACACE
P 8500 2750
F 0 "R1" V 8304 2750 50  0000 C CNN
F 1 "5K1" V 8395 2750 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8500 2750 50  0001 C CNN
F 3 "~" H 8500 2750 50  0001 C CNN
	1    8500 2750
	0    1    1    0   
$EndComp
$Comp
L Device:R_Small R2
U 1 1 5E9ACFBC
P 8500 2850
F 0 "R2" V 8696 2850 50  0000 C CNN
F 1 "5K1" V 8605 2850 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8500 2850 50  0001 C CNN
F 3 "~" H 8500 2850 50  0001 C CNN
	1    8500 2850
	0    -1   -1   0   
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 5E9AD5C7
P 8250 3000
F 0 "#PWR0110" H 8250 2750 50  0001 C CNN
F 1 "GND" H 8255 2827 50  0000 C CNN
F 2 "" H 8250 3000 50  0001 C CNN
F 3 "" H 8250 3000 50  0001 C CNN
	1    8250 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	9100 2750 8600 2750
Wire Wire Line
	9100 2850 8600 2850
Wire Wire Line
	8400 2750 8250 2750
Wire Wire Line
	8250 2750 8250 2850
Wire Wire Line
	8400 2850 8250 2850
Connection ~ 8250 2850
Wire Wire Line
	8250 2850 8250 3000
$Comp
L power:+5V #PWR0111
U 1 1 5E9B1898
P 9200 4500
F 0 "#PWR0111" H 9200 4350 50  0001 C CNN
F 1 "+5V" H 9215 4673 50  0000 C CNN
F 2 "" H 9200 4500 50  0001 C CNN
F 3 "" H 9200 4500 50  0001 C CNN
	1    9200 4500
	1    0    0    -1  
$EndComp
NoConn ~ 9100 3750
NoConn ~ 9100 3650
Wire Wire Line
	6300 4700 8800 4700
Wire Wire Line
	9200 4700 8800 4700
NoConn ~ 6300 3400
NoConn ~ 6300 3500
NoConn ~ 6300 3600
NoConn ~ 6300 3700
NoConn ~ 6300 3800
NoConn ~ 6300 3900
NoConn ~ 6300 4000
NoConn ~ 6300 4100
NoConn ~ 6300 4200
NoConn ~ 6300 4300
NoConn ~ 6300 4400
NoConn ~ 6300 4500
NoConn ~ 6300 4600
NoConn ~ 6300 4900
NoConn ~ 6300 5000
NoConn ~ 6300 5200
NoConn ~ 6300 5400
NoConn ~ 6300 5600
NoConn ~ 6300 5800
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5E9E59F6
P 9200 4500
F 0 "#FLG0101" H 9200 4575 50  0001 C CNN
F 1 "PWR_FLAG" H 9200 4673 50  0000 C CNN
F 2 "" H 9200 4500 50  0001 C CNN
F 3 "~" H 9200 4500 50  0001 C CNN
	1    9200 4500
	-1   0    0    1   
$EndComp
Connection ~ 9200 4500
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5E9E7F2D
P 9500 5500
F 0 "#FLG0102" H 9500 5575 50  0001 C CNN
F 1 "PWR_FLAG" H 9500 5673 50  0000 C CNN
F 2 "" H 9500 5500 50  0001 C CNN
F 3 "~" H 9500 5500 50  0001 C CNN
	1    9500 5500
	-1   0    0    1   
$EndComp
Text Label 1900 4800 0    50   ~ 0
UART0_TX
Text Label 1900 4900 0    50   ~ 0
UART0_RX
Text Label 2100 3400 0    50   ~ 0
SW_C
Text Label 2100 3500 0    50   ~ 0
SW_1
Text Label 2100 3600 0    50   ~ 0
SW_2
Text Label 2100 3700 0    50   ~ 0
SW_4
Text Label 2100 3800 0    50   ~ 0
SW_8
Text Label 6400 2850 0    50   ~ 0
SDC0_CD
Text Label 6450 4700 0    50   ~ 0
USB_D+
Text Label 6450 4800 0    50   ~ 0
USB_D-
Text Label 6450 5100 0    50   ~ 0
SDC0_D1
Text Label 6450 5300 0    50   ~ 0
SDC0_D0
Text Label 6450 5500 0    50   ~ 0
SDC0_CLK
Text Label 6450 5700 0    50   ~ 0
SDC0_CMD
Text Label 6450 5900 0    50   ~ 0
SDC0_D3
Text Label 6450 6000 0    50   ~ 0
SDC0_D2
Text Label 8700 2750 0    50   ~ 0
USB_CC1
Text Label 8700 2850 0    50   ~ 0
USB_CC2
$Comp
L Device:C_Small C1
U 1 1 5E9A0607
P 7150 2700
F 0 "C1" H 7058 2654 50  0000 R CNN
F 1 "100n" H 7058 2745 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 7150 2700 50  0001 C CNN
F 3 "~" H 7150 2700 50  0001 C CNN
	1    7150 2700
	-1   0    0    1   
$EndComp
Wire Wire Line
	7150 2800 7150 2950
Wire Wire Line
	7150 2950 7350 2950
Wire Wire Line
	7350 2500 7350 2950
Connection ~ 7350 2950
Wire Wire Line
	7150 2550 4850 2550
Wire Wire Line
	4850 2550 4850 3100
Connection ~ 7150 2550
Wire Wire Line
	7150 2550 7150 2600
Text Label 6400 2550 0    50   ~ 0
3V3
$Comp
L Connector:USB_C_Receptacle_USB2.0 J4
U 1 1 5E94C9AC
P 9700 3150
F 0 "J4" H 10100 4000 50  0000 R CNN
F 1 "USB_C_Receptacle_USB2.0" H 10100 3900 50  0000 R CNN
F 2 "Connector_USB:USB_C_HRO_TYPE_C_31_M_12" H 9850 3150 50  0001 C CNN
F 3 "https://datasheet.lcsc.com/szlcsc/1811131825_Korean-Hroparts-Elec-TYPE-C-31-M-12_C165948.pdf" H 9850 3150 50  0001 C CNN
	1    9700 3150
	-1   0    0    -1  
$EndComp
Wire Wire Line
	9100 3050 8600 3050
Wire Wire Line
	8600 3050 8600 3150
Connection ~ 8600 4800
Wire Wire Line
	8600 4800 6300 4800
Wire Wire Line
	9100 3150 8600 3150
Connection ~ 8600 3150
Wire Wire Line
	8600 3150 8600 4800
Wire Wire Line
	9100 3350 8800 3350
Wire Wire Line
	8800 3350 8800 4700
Connection ~ 8800 4700
Wire Wire Line
	9100 3250 8800 3250
Wire Wire Line
	8800 3250 8800 3350
Connection ~ 8800 3350
Wire Wire Line
	9600 5100 9600 5150
Connection ~ 9500 5500
Wire Wire Line
	8600 4800 9200 4800
Wire Wire Line
	9700 4050 9700 4250
Wire Wire Line
	9700 4250 9900 4250
Wire Wire Line
	9900 4250 9900 5500
Connection ~ 9900 5500
Wire Wire Line
	9900 5500 9950 5500
Wire Wire Line
	9600 5150 10000 5150
Wire Wire Line
	10000 5150 10000 4050
Wire Wire Line
	9500 5500 9600 5500
Wire Wire Line
	9600 5400 9600 5500
Connection ~ 9600 5500
Wire Wire Line
	9600 5500 9900 5500
Wire Wire Line
	9600 5200 9600 5150
Connection ~ 9600 5150
$Comp
L Mechanical:MountingHole H1
U 1 1 5E962665
P 3200 7300
F 0 "H1" H 3300 7346 50  0000 L CNN
F 1 "MountingHole" H 3300 7255 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 3200 7300 50  0001 C CNN
F 3 "~" H 3200 7300 50  0001 C CNN
	1    3200 7300
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H2
U 1 1 5E962DA8
P 4000 7300
F 0 "H2" H 4100 7346 50  0000 L CNN
F 1 "MountingHole" H 4100 7255 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 4000 7300 50  0001 C CNN
F 3 "~" H 4000 7300 50  0001 C CNN
	1    4000 7300
	1    0    0    -1  
$EndComp
$Comp
L Mechanical:MountingHole H3
U 1 1 5E96F02B
P 4800 7300
F 0 "H3" H 4900 7346 50  0000 L CNN
F 1 "MountingHole" H 4900 7255 50  0000 L CNN
F 2 "MountingHole:MountingHole_3.2mm_M3_DIN965_Pad" H 4800 7300 50  0001 C CNN
F 3 "~" H 4800 7300 50  0001 C CNN
	1    4800 7300
	1    0    0    -1  
$EndComp
$Comp
L Device:C_Small C5
U 1 1 5E980F14
P 2500 4450
F 0 "C5" H 2408 4404 50  0000 R CNN
F 1 "100n" H 2408 4495 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2500 4450 50  0001 C CNN
F 3 "~" H 2500 4450 50  0001 C CNN
	1    2500 4450
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C6
U 1 1 5E9821E1
P 2700 4450
F 0 "C6" H 2608 4404 50  0000 R CNN
F 1 "100n" H 2608 4495 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2700 4450 50  0001 C CNN
F 3 "~" H 2700 4450 50  0001 C CNN
	1    2700 4450
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C7
U 1 1 5E9823F1
P 2900 4450
F 0 "C7" H 2808 4404 50  0000 R CNN
F 1 "100n" H 2808 4495 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2900 4450 50  0001 C CNN
F 3 "~" H 2900 4450 50  0001 C CNN
	1    2900 4450
	-1   0    0    1   
$EndComp
$Comp
L Device:C_Small C4
U 1 1 5E98278D
P 2300 4450
F 0 "C4" H 2208 4404 50  0000 R CNN
F 1 "100n" H 2208 4495 50  0000 R CNN
F 2 "Capacitor_SMD:C_0603_1608Metric" H 2300 4450 50  0001 C CNN
F 3 "~" H 2300 4450 50  0001 C CNN
	1    2300 4450
	-1   0    0    1   
$EndComp
Wire Wire Line
	2300 4200 2300 4350
Connection ~ 2300 4200
Wire Wire Line
	2500 4000 2500 4350
Connection ~ 2500 4000
Wire Wire Line
	2700 4350 2700 3800
Connection ~ 2700 3800
Wire Wire Line
	2900 4350 2900 3600
Connection ~ 2900 3600
Wire Wire Line
	2050 5250 2300 5250
Wire Wire Line
	2300 5250 2300 4550
Connection ~ 2050 5250
Wire Wire Line
	2050 5250 2050 5500
Wire Wire Line
	2300 5250 2500 5250
Wire Wire Line
	2500 5250 2500 4550
Connection ~ 2300 5250
Wire Wire Line
	2500 5250 2700 5250
Wire Wire Line
	2700 5250 2700 4550
Connection ~ 2500 5250
Wire Wire Line
	2700 5250 2900 5250
Wire Wire Line
	2900 5250 2900 4550
Connection ~ 2700 5250
$Comp
L Device:R_Small R3
U 1 1 5F0214E6
P 8000 800
F 0 "R3" V 8196 800 50  0000 C CNN
F 1 "33K" V 8105 800 50  0000 C CNN
F 2 "Resistor_SMD:R_0603_1608Metric" H 8000 800 50  0001 C CNN
F 3 "~" H 8000 800 50  0001 C CNN
	1    8000 800 
	0    -1   -1   0   
$EndComp
$EndSCHEMATC
