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
L Switch:SW_Coded_SH-7050 SW1
U 1 1 5E695944
P 2950 3250
F 0 "SW1" H 3007 3717 50  0000 C CNN
F 1 "SW_Coded_SH-7050" H 3007 3626 50  0000 C CNN
F 2 "Button_Switch_THT:Nidec_Copal_SH-7010C" H 2650 2800 50  0001 L CNN
F 3 "https://www.nidec-copal-electronics.com/e/catalog/switch/sh-7000.pdf" H 2950 3250 50  0001 C CNN
	1    2950 3250
	1    0    0    -1  
$EndComp
NoConn ~ 3450 4000
NoConn ~ 3550 4000
NoConn ~ 3650 4000
NoConn ~ 3750 4000
NoConn ~ 3850 4000
NoConn ~ 3950 4000
Wire Wire Line
	3450 2500 3450 3050
Wire Wire Line
	3450 3050 3350 3050
Wire Wire Line
	3550 2500 3550 3150
Wire Wire Line
	3550 3150 3350 3150
Wire Wire Line
	3650 2500 3650 3250
Wire Wire Line
	3650 3250 3350 3250
Wire Wire Line
	3750 2500 3750 3350
Wire Wire Line
	3850 2500 3850 3450
Wire Wire Line
	3850 3450 3350 3450
NoConn ~ 3950 2500
$Comp
L Connector_Generic:Conn_01x07 J1
U 1 1 5E69FBFF
P 3750 2300
F 0 "J1" V 3714 1912 50  0000 R CNN
F 1 "Conn_01x07" V 3623 1912 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x07_P2.54mm_Vertical" H 3750 2300 50  0001 C CNN
F 3 "~" H 3750 2300 50  0001 C CNN
	1    3750 2300
	0    -1   -1   0   
$EndComp
$Comp
L Connector_Generic:Conn_01x07 J2
U 1 1 5E6A0BFC
P 3750 4200
F 0 "J2" V 3622 3812 50  0000 R CNN
F 1 "Conn_01x07" V 3713 3812 50  0000 R CNN
F 2 "Connector_PinSocket_2.54mm:PinSocket_1x07_P2.54mm_Vertical" H 3750 4200 50  0001 C CNN
F 3 "~" H 3750 4200 50  0001 C CNN
	1    3750 4200
	0    -1   1    0   
$EndComp
NoConn ~ 4050 4000
$Comp
L power:GND #PWR01
U 1 1 5E6A21AB
P 4050 2500
F 0 "#PWR01" H 4050 2250 50  0001 C CNN
F 1 "GND" H 4055 2327 50  0000 C CNN
F 2 "" H 4050 2500 50  0001 C CNN
F 3 "" H 4050 2500 50  0001 C CNN
	1    4050 2500
	1    0    0    -1  
$EndComp
$Comp
L Switch:SW_Coded_SH-7010 SW2
U 1 1 5E6ABE40
P 4600 3250
F 0 "SW2" H 4270 3296 50  0000 R CNN
F 1 "SW_Coded_SH-7010" H 4270 3205 50  0000 R CNN
F 2 "Button_Switch_THT:ROT_10" H 4300 2800 50  0001 L CNN
F 3 "https://www.nidec-copal-electronics.com/e/catalog/switch/sh-7000.pdf" H 4600 3250 50  0001 C CNN
	1    4600 3250
	-1   0    0    -1  
$EndComp
Wire Wire Line
	4200 3050 3450 3050
Connection ~ 3450 3050
Wire Wire Line
	3550 3150 4200 3150
Connection ~ 3550 3150
Wire Wire Line
	4200 3250 3650 3250
Connection ~ 3650 3250
Wire Wire Line
	3350 3350 3750 3350
Connection ~ 3750 3350
Wire Wire Line
	3750 3350 4200 3350
Wire Wire Line
	3850 3450 4200 3450
Connection ~ 3850 3450
$EndSCHEMATC
