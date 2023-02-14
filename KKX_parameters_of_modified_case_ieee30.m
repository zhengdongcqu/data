function [baseMVA,bus,busPmax,busPmin,busQmax,busQmin,busPG,busQG,gen,branch, PBase ,PFBase,busLoadImportant]= KKX_triple_case_ieee30
%RBTS_Reliability_Test_System   Defines the reliability test system data of the RBTS
%   [baseMVA, bus,busPmax,busPmin,busQmax,busQmin,gen,branch, PBase ,FBase] = RBTS_Reliability_Test_System
%Ref.<<A Reliability Test System For Educational Purposes-Basic Data>>
%IEEE Transactions on Power System,Vol.4,N0.3,August 1989
%PBase:The Probability of All component in normal state
%PFBase:The Sum of the failure rate of all the component

%   Bus Data Format
%       1   bus number (1 to 29997)
%       2   bus type
%               PQ bus          = 1
%               PV bus          = 2
%               reference bus   = 3
%       3   Pd, real power demand (MW)
%       4   Qd, reactive power demand (MVAR)
%       5   Gs, shunt conductance (MW (demanded?) at V = 1.0 p.u.)
%       6   Bs, shunt susceptance (MVAR (injected?) at V = 1.0 p.u.)
%       7   area number, 1-100
%       8   Vm, voltage magnitude (p.u.)
%       9   Va, voltage angle (degrees)
%       10  baseKV, base voltage (kV)
%       11  maxVm, maximum voltage magnitude (p.u.)
%       12  minVm, minimum voltage magnitude (p.u.)


%       13  PGMax, maximum active power wthich can be ejected into the net by the generator installed on this bus
%       14  PGMin, minimum active power wthich can be ejected into the net by the generator installed on this bus
%       15  QGMax, maximum reactive power wthich can be ejected into the net by the generator installed on this bus
%       16  QGMin, minimum reactive power wthich can be ejected into the net by the generator installed on this bus
%       17  PG, actual active power wthich is ejected into the net by the generator installed on this bus
%       18  QG, actusl reactive power wthich is ejected into the net by the generator installed on this bus
%       19  LOLP, Loss of Load Probability
%       20  LOLE, Loss of Load Expection
%       21  LOLF, Loss of Load Frequency
%       22  LOLD, Loss of Load Duration
%       23  EDNS, Expected Demand Not Supplied
%       24  EENS, Expected Energy Not Supplied
%       25  LAM_P, %% Lagrange multiplier on real power mismatch 
%       26  LAM_Q, %% Lagrange multiplier on reactive power mismatch
%       27  MU_VMAX, %% Kuhn-Tucker multiplier on upper voltage limit
%       28  MU_VMIN, %% Kuhn-Tucker multiplier on lower voltage limit
%       29  MU_PMAX, %% Kuhn-Tucker multiplier on upper Pg limit
%       30  MU_PMIN, %% Kuhn-Tucker multiplier on lower Pg limit
%       31  MU_QMAX, %% Kuhn-Tucker multiplier on upper Qg limit
%       32  MU_QMIN, %% Kuhn-Tucker multiplier on lower Qg limit
       
%       Note:the bus data used between numner 13 and number 32 is set by the programe dynamically


%
%   Generator Data Format
%       1   bus number
%       2   Pmax, maximum real power output (MW)
%       3   Pmin, minimum real power output (MW)
%       4   Qmax, maximum reactive power output (MVAR)
%       5   Qmin, minimum reactive power output (MVAR)
%       6   status, 1 - machine in service, 0 - machine out of service
%       7   Lamda, Failure Rate
%       8   MTTF, Repair duration
%       9   PG,original real power output (MW)
%       10  QG,original reactive power output (MVAR)

%       11   PFailure, Probability of Failure
%       Note:the generator data used between numner 9 and number 9 is caculated by the programme
%       
%
%% branch data
%   Branch Data Format
%       1   f, from bus number
%       2   t, to bus number
%       3   r, resistance (p.u.)
%       4   x, reactance (p.u.)
%       5   b, total line charging susceptance (p.u.)
%       6   rate, MVA rating 
%       7   ratio, transformer off nominal turns ratio ( = 0 for lines )
%           (taps at 'from' bus, impedance at 'to' bus, i.e. ratio = Vf / Vt)
%       8   angle, transformer phase shift angle (degrees)
%       9   branch status, 1 - in service, 0 - out of service
%       10  Lamda, Failure Rate
%       11  MTTF, Repair duration
%       12  TCSC setting

%       13  PFailure, Probability of Failure
%       14  PF, active power injected at "from" bus end (MW)		(not in PTI format)
%       15  QF, reactive power injected at "from" bus end (MVAR)	(not in PTI format)
%       16  PT, active power injected at "to" bus end (MW)			(not in PTI format)
%       17  QT, reactive power injected at "to" bus end (MVAR)	(not in PTI format)
%       18  MU_SF, Kuhn-Tucker multiplier on MVA limit at "from" bus (u/MVA)
%       19  MU_ST, Kuhn-Tucker multiplier on MVA limit at "to" bus (u/MVA)
%       20  KT_MAXANGLE_TPST, Kuhn-Tucker multiplier on shifting transformer angle upper limit 
%       21  KT_MINANGLE_TPST, Kuhn-Tucker multiplier on shifting transformer angle lower limit 
%       22  KT_MAXANGLE_TCSC, Kuhn-Tucker multiplier on TSCS Xc upper  limit
%       23  KT_MINANGLE_TCSC, Kuhn-Tucker multiplier on TCSC Xc lower  limit
[PQ, PV, REF, BUS_I, BUS_TYPE, PD, QD, GS, BS, BUS_AREA, VM, ...
	VA, BASE_KV, VMAX, VMIN, PGMAX,PGMIN,QGMAX,QGMIN,PG,QG,LOLP,LOLE,LOLF,LOLD,EDNS,EENS,...
    LAM_P,LAM_Q,MU_VMAX,MU_VMIN,MU_PMAX,MU_PMIN,MU_QMAX,MU_QMIN] = idx_bus;
[GEN_BUS, GEN_PMAX, GEN_PMIN, GEN_QMAX, GEN_QMIN, GEN_STATUS, ...
	GEN_LAMDA,GEN_MTTF,GEN_PG,GEN_QG,GEN_PFAILURE] = idx_gen;
[F_BUS, T_BUS, BR_R, BR_X, BR_B, RATE, TAP, SHIFT_ANGLE, BR_STATUS, BR_LAMDA,...
        BR_MTTF,TCSC_X, BR_PFAILURE, PF, QF, PT, QT, MU_SF, MU_ST, KT_MAXANGLE_TPST,KT_MINANGLE_TPST,KT_MAX_X_TCSC,KT_MIN_X_TCSC] = idx_brch;
[NEWTON,FDFP_XB,FDFP_BX,DCPF] = idx_powerflow;


%% system MVA base  
baseMVA = 100.0000;

%% bus data

%   Bus Data Format
%       1   bus number (1 to 29997)
%       2   bus type
%               PQ bus          = 1
%               PV bus          = 2
%               reference bus   = 3
%       3   Pd, real power demand (MW)
%       4   Qd, reactive power demand (MVAR)
%       5   Gs, shunt conductance (MW (demanded?) at V = 1.0 p.u.)
%       6   Bs, shunt susceptance (MVAR (injected?) at V = 1.0 p.u.)
%       7   area number, 1-100
%       8   Vm, voltage magnitude (p.u.)
%       9   Va, voltage angle (degrees)
%       10  baseKV, base voltage (kV)
%       11  maxVm, maximum voltage magnitude (p.u.)
%       12  minVm, minimum voltage magnitude (p.u.)

%% bus data
%	bus_i	type	Pd	Qd	Gs	Bs	area	Vm	Va	baseKV	zone	Vmax	Vmin
bus = [
    %区域1
    1	3	0	0	0	0	1	1.06	0	132	1	1.06	0.94;
    2	2	21.7	12.7	0	0	1	1.043	-5.48	132	1	1.06	0.94;
    3	1	2.4	1.2	0	0	1	1.021	-7.96	132	1	1.06	0.94;
    4	1	7.6	1.6	0	0	1	1.012	-9.62	132	1	1.06	0.94;
    5	2	94.2	19	0	0	1	1.01	-14.37	132	1	1.06	0.94;
    6	1	0	0	0	0	1	1.01	-11.34	132	1	1.06	0.94;
    7	1	22.8	10.9	0	0	1	1.002	-13.12	132	1	1.06	0.94;
    8	2	30	30	0	0	1	1.01	-12.1	132	1	1.06	0.94;
    9	1	0	0	0	0	1	1.051	-14.38	1	1	1.06	0.94;
    10	1	5.8	2	0	19	1	1.045	-15.97	33	1	1.06	0.94;
    11	2	0	0	0	0	1	1.082	-14.39	11	1	1.06	0.94;
    12	1	11.2	7.5	0	0	1	1.057	-15.24	33	1	1.06	0.94;
    13	2	0	0	0	0	1	1.071	-15.24	11	1	1.06	0.94;
    14	1	6.2	1.6	0	0	1	1.042	-16.13	33	1	1.06	0.94;
    15	1	8.2	2.5	0	0	1	1.038	-16.22	33	1	1.06	0.94;
    16	1	3.5	1.8	0	0	1	1.045	-15.83	33	1	1.06	0.94;
    17	1	9	5.8	0	0	1	1.04	-16.14	33	1	1.06	0.94;
    18	1	3.2	0.9	0	0	1	1.028	-16.82	33	1	1.06	0.94;
    19	1	9.5	3.4	0	0	1	1.026	-17	33	1	1.06	0.94;
    20	1	2.2	0.7	0	0	1	1.03	-16.8	33	1	1.06	0.94;
    21	1	17.5	11.2	0	0	1	1.033	-16.42	33	1	1.06	0.94;
    22	1	0	0	0	0	1	1.033	-16.41	33	1	1.06	0.94;
    23	1	3.2	1.6	0	0	1	1.027	-16.61	33	1	1.06	0.94;
    24	1	8.7	6.7	0	4.3	1	1.021	-16.78	33	1	1.06	0.94;
    25	1	0	0	0	0	1	1.017	-16.35	33	1	1.06	0.94;
    26	1	3.5	2.3	0	0	1	1	-16.77	33	1	1.06	0.94;
    27	1	0	0	0	0	1	1.023	-15.82	33	1	1.06	0.94;
    28	1	0	0	0	0	1	1.007	-11.97	132	1	1.06	0.94;
    29	1	2.4	0.9	0	0	1	1.003	-17.06	33	1	1.06	0.94;
    30	1	10.6	1.9	0	0	1	0.992	-17.94	33	1	1.06	0.94;
    %区域2
    31	2	0	0	0	0	1	1.06	0	132	1	1.06	0.94;
    32	2	21.7	12.7	0	0	1	1.043	-5.48	132	1	1.06	0.94;
    33	1	2.4	1.2	0	0	1	1.021	-7.96	132	1	1.06	0.94;
    34	1	7.6	1.6	0	0	1	1.012	-9.62	132	1	1.06	0.94;
    35	2	94.2	19	0	0	1	1.01	-14.37	132	1	1.06	0.94;
    36	1	0	0	0	0	1	1.01	-11.34	132	1	1.06	0.94;
    37	1	22.8	10.9	0	0	1	1.002	-13.12	132	1	1.06	0.94;
    38	2	30	30	0	0	1	1.01	-12.1	132	1	1.06	0.94;
    39	1	0	0	0	0	1	1.051	-14.38	1	1	1.06	0.94;
    40	1	5.8	2	0	19	1	1.045	-15.97	33	1	1.06	0.94;
    41	2	0	0	0	0	1	1.082	-14.39	11	1	1.06	0.94;
    42	1	11.2	7.5	0	0	1	1.057	-15.24	33	1	1.06	0.94;
    43	2	0	0	0	0	1	1.071	-15.24	11	1	1.06	0.94;
    44	1	6.2	1.6	0	0	1	1.042	-16.13	33	1	1.06	0.94;
    45	1	8.2	2.5	0	0	1	1.038	-16.22	33	1	1.06	0.94;
    46	1	3.5	1.8	0	0	1	1.045	-15.83	33	1	1.06	0.94;
    47	1	9	5.8	0	0	1	1.04	-16.14	33	1	1.06	0.94;
    48	1	3.2	0.9	0	0	1	1.028	-16.82	33	1	1.06	0.94;
    49	1	9.5	3.4	0	0	1	1.026	-17	33	1	1.06	0.94;
    50	1	2.2	0.7	0	0	1	1.03	-16.8	33	1	1.06	0.94;
    51	1	17.5	11.2	0	0	1	1.033	-16.42	33	1	1.06	0.94;
    52	1	0	0	0	0	1	1.033	-16.41	33	1	1.06	0.94;
    53	1	3.2	1.6	0	0	1	1.027	-16.61	33	1	1.06	0.94;
    54	1	8.7	6.7	0	4.3	1	1.021	-16.78	33	1	1.06	0.94;
    55	1	0	0	0	0	1	1.017	-16.35	33	1	1.06	0.94;
    56	1	3.5	2.3	0	0	1	1	-16.77	33	1	1.06	0.94;
    57	1	0	0	0	0	1	1.023	-15.82	33	1	1.06	0.94;
    58	1	0	0	0	0	1	1.007	-11.97	132	1	1.06	0.94;
    59	1	2.4	0.9	0	0	1	1.003	-17.06	33	1	1.06	0.94;
    60	1	10.6	1.9	0	0	1	0.992	-17.94	33	1	1.06	0.94;
    %区域3
    61	2	0	0	0	0	1	1.06	0	132	1	1.06	0.94;
    62	2	21.7	12.7	0	0	1	1.043	-5.48	132	1	1.06	0.94;
    63	1	2.4	1.2	0	0	1	1.021	-7.96	132	1	1.06	0.94;
    64	1	7.6	1.6	0	0	1	1.012	-9.62	132	1	1.06	0.94;
    65	2	94.2	19	0	0	1	1.01	-14.37	132	1	1.06	0.94;
    66	1	0	0	0	0	1	1.01	-11.34	132	1	1.06	0.94;
    67	1	22.8	10.9	0	0	1	1.002	-13.12	132	1	1.06	0.94;
    68	2	30	30	0	0	1	1.01	-12.1	132	1	1.06	0.94;
    69	1	0	0	0	0	1	1.051	-14.38	1	1	1.06	0.94;
    70	1	5.8	2	0	19	1	1.045	-15.97	33	1	1.06	0.94;
    71	2	0	0	0	0	1	1.082	-14.39	11	1	1.06	0.94;
    72	1	11.2	7.5	0	0	1	1.057	-15.24	33	1	1.06	0.94;
    73	2	0	0	0	0	1	1.071	-15.24	11	1	1.06	0.94;
    74	1	6.2	1.6	0	0	1	1.042	-16.13	33	1	1.06	0.94;
    75	1	8.2	2.5	0	0	1	1.038	-16.22	33	1	1.06	0.94;
    76	1	3.5	1.8	0	0	1	1.045	-15.83	33	1	1.06	0.94;
    77	1	9	5.8	0	0	1	1.04	-16.14	33	1	1.06	0.94;
    78	1	3.2	0.9	0	0	1	1.028	-16.82	33	1	1.06	0.94;
    79	1	9.5	3.4	0	0	1	1.026	-17	33	1	1.06	0.94;
    80	1	2.2	0.7	0	0	1	1.03	-16.8	33	1	1.06	0.94;
    81	1	17.5	11.2	0	0	1	1.033	-16.42	33	1	1.06	0.94;
    82	1	0	0	0	0	1	1.033	-16.41	33	1	1.06	0.94;
    83	1	3.2	1.6	0	0	1	1.027	-16.61	33	1	1.06	0.94;
    84	1	8.7	6.7	0	4.3	1	1.021	-16.78	33	1	1.06	0.94;
    85	1	0	0	0	0	1	1.017	-16.35	33	1	1.06	0.94;
    86	1	3.5	2.3	0	0	1	1	-16.77	33	1	1.06	0.94;
    87	1	0	0	0	0	1	1.023	-15.82	33	1	1.06	0.94;
    88	1	0	0	0	0	1	1.007	-11.97	132	1	1.06	0.94;
    89	1	2.4	0.9	0	0	1	1.003	-17.06	33	1	1.06	0.94;
    90	1	10.6	1.9	0	0	1	0.992	-17.94	33	1	1.06	0.94;
    ];
bus(:,11)=[];

busLoadImportant=zeros(size(bus,1),4);
busLoadImportant(:,1)=bus(:,1);
busLoadImportant(find(bus(:,3)~=0),2)=1;
busLoadImportant(find(bus(:,3)~=0),3)=1;
busLoadImportant(find(bus(:,3)~=0),4)=1;

%% generator data
%       1   bus number
%       2   Pmax, maximum real power output (MW)
%       3   Pmin, minimum real power output (MW)
%       4   Qmax, maximum reactive power output (MVAR)
%       5   Qmin, minimum reactive power output (MVAR)
%       6   status, 1 - machine in service, 0 - machine out of service
%       7   Tor, Failure Rate
%       8   MTTF, Repair duration
%       9   PG,original real power output (MW)
%       10  QG,original reactive power output (MVAR)
%       11   PFailure, Probability of Failure

%% generator data
%	bus	Pg	Qg	Qmax	Qmin	Vg	mBase	status	Pmax	Pmin	Pc1	Pc2	Qc1min	Qc1max	Qc2min	Qc2max	ramp_agc	ramp_10	ramp_30	ramp_q	apf
gen_temp = [
    %区域1
    1	260.2	-16.1	10	0	1.06	100	1	200	50	0	0	0	0	0	0	0	0	0	0	0 0;
    2	40	50	50	-40	1.045	100	1	80	20	0	0	0	0	0	0	0	0	0	0	0 0;
    5	0	37	40	-40	1.01	100	1	50	15	0	0	0	0	0	0	0	0	0	0	0 0;
    5	0	37	40	-40	1.01	100	1	50	15	0	0	0	0	0	0	0	0	0	0	0 1;
    8	0	37.3	40	-10	1.01	100	1	35	10	0	0	0	0	0	0	0	0	0	0	0 0;
    11	0	16.2	24	-6	1.082	100	1	30	10	0	0	0	0	0	0	0	0	0	0	0 0;
    13	0	10.6	24	-6	1.071	100	1	40	12	0	0	0	0	0	0	0	0	0	0	0 0;
    %区域2
    31	260.2	-16.1	10	0	1.06	100	1	200	50	0	0	0	0	0	0	0	0	0	0	0 0;
    32	40	50	50	-40	1.045	100	1	80	20	0	0	0	0	0	0	0	0	0	0	0 0;
    35	0	37	40	-40	1.01	100	1	50	15	0	0	0	0	0	0	0	0	0	0	0 0;
    35	0	37	40	-40	1.01	100	1	50	15	0	0	0	0	0	0	0	0	0	0	0 1;
    38	0	37.3	40	-10	1.01	100	1	35	10	0	0	0	0	0	0	0	0	0	0	0 0;
    41	0	16.2	24	-6	1.082	100	1	30	10	0	0	0	0	0	0	0	0	0	0	0 0;
    43	0	10.6	24	-6	1.071	100	1	40	12	0	0	0	0	0	0	0	0	0	0	0 0;
    %区域3
    61	260.2	-16.1	10	0	1.06	100	1	200	50	0	0	0	0	0	0	0	0	0	0	0 0;
    62	40	50	50	-40	1.045	100	1	80	20	0	0	0	0	0	0	0	0	0	0	0 0;
    65	0	37	40	-40	1.01	100	1	50	15	0	0	0	0	0	0	0	0	0	0	0 0;
    65	0	37	40	-40	1.01	100	1	50	15	0	0	0	0	0	0	0	0	0	0	0 1;
    68	0	37.3	40	-10	1.01	100	1	35	10	0	0	0	0	0	0	0	0	0	0	0 0;
    71	0	16.2	24	-6	1.082	100	1	30	10	0	0	0	0	0	0	0	0	0	0	0 0;
    73	0	10.6	24	-6	1.071	100	1	40	12	0	0	0	0	0	0	0	0	0	0	0 0;
];

gen_temp(:,9)=[100;120;150;100;100;80;80;100;120;150;100;100;80;80;100;120;150;100;100;80;80];
gen=zeros(size(gen_temp,1),10);
gen(:,1)=gen_temp(:,1);%       1   bus number
gen(:,2)=gen_temp(:,9);%       2   Pmax, maximum real power output (MW)
gen(:,3)=0*gen_temp(:,10);%       3   Pmin, minimum real power output (MW)
gen(:,4)=gen_temp(:,4);%4   Qmax, maximum reactive power output (MVAR)
gen(:,5)=gen_temp(:,5);%       5   Qmin, minimum reactive power output (MVAR)
gen(:,6)=ones(size(gen_temp,1),1);%       6   status, 1 - machine in service, 0 - machine out of service

gen(:,7)=repmat([7.61740;7.96360;7.96360;7.30000;7.30000;4.46940;4.46940],3,1);%       7   Tor, Failure Rate
gen(:,8)=repmat([100;100;100;50;50;40;40],3,1);%       8   MTTF, Repair duration

gen(:,9)=0*gen_temp(:,2);%       9   PG,original real power output (MW)
gen(:,10)=0*gen_temp(:,3);%       10  QG,original reactive power output (MVAR)

gen(:,11) = 1-8760./(gen(:,7).*gen(:,8)+8760);%       11   PFailure, Probability of Failure

%% branch data
%       1   f, from bus number
%       2   t, to bus number
%       3   r, resistance (p.u.)
%       4   x, reactance (p.u.)
%       5   b, total line charging susceptance (p.u.)
%       6   rate, MVA rating 
%       7   ratio, transformer off nominal turns ratio ( = 0 for lines )
%           (taps at 'from' bus, impedance at 'to' bus, i.e. ratio = Vf / Vt)
%       8   angle, transformer phase shift angle (degrees)
%       9   branch status, 1 - in service, 0 - out of service
%       10  Lamda, Failure Rate
%       11  MTTF, Repair duration
%       12  TCSC setting

%       13  PFailure, Probability of Failure
%       14  PF, active power injected at "from" bus end (MW)		(not in PTI format)
%       15  QF, reactive power injected at "from" bus end (MVAR)	(not in PTI format)
%       16  PT, active power injected at "to" bus end (MW)			(not in PTI format)
%       17  QT, reactive power injected at "to" bus end (MVAR)	(not in PTI format)
%       18  MU_SF, Kuhn-Tucker multiplier on MVA limit at "from" bus (u/MVA)
%       19  MU_ST, Kuhn-Tucker multiplier on MVA limit at "to" bus (u/MVA)
%       20  KT_MAXANGLE_TPST, Kuhn-Tucker multiplier on shifting transformer angle upper limit 
%       21  KT_MINANGLE_TPST, Kuhn-Tucker multiplier on shifting transformer angle lower limit 
%       22  KT_MAXANGLE_TCSC, Kuhn-Tucker multiplier on TSCS Xc upper  limit
%       23  KT_MINANGLE_TCSC, Kuhn-Tucker multiplier on TCSC Xc lower  limit

%% branch data
%	fbus	tbus	r	x	b	rateA	rateB	rateC	ratio	angle	status	angmin	angmax
branch_temp = [
    %区域1
    1	2	0.0192	0.0575	0.0528	9900	0	0	0	0	1	-360	360;
    1	3	0.0452	0.1652	0.0408	9900	0	0	0	0	1	-360	360;
    2	4	0.057	0.1737	0.0368	9900	0	0	0	0	1	-360	360;
    3	4	0.0132	0.0379	0.0084	9900	0	0	0	0	1	-360	360;
    2	5	0.0472	0.1983	0.0418	9900	0	0	0	0	1	-360	360;
    2	6	0.0581	0.1763	0.0374	9900	0	0	0	0	1	-360	360;
    4	6	0.0119	0.0414	0.009	9900	0	0	0	0	1	-360	360;
    5	7	0.046	0.116	0.0204	9900	0	0	0	0	1	-360	360;
    6	7	0.0267	0.082	0.017	9900	0	0	0	0	1	-360	360;
    6	8	0.012	0.042	0.009	9900	0	0	0	0	1	-360	360;
    6	9	0	0.208	0	9900	0	0	0.978	0	1	-360	360;
    6	10	0	0.556	0	9900	0	0	0.969	0	1	-360	360;
    9	11	0	0.208	0	9900	0	0	0	0	1	-360	360;
    9	10	0	0.11	0	9900	0	0	0	0	1	-360	360;
    4	12	0	0.256	0	9900	0	0	0.932	0	1	-360	360;
    12	13	0	0.14	0	9900	0	0	0	0	1	-360	360;
    12	14	0.1231	0.2559	0	9900	0	0	0	0	1	-360	360;
    12	15	0.0662	0.1304	0	9900	0	0	0	0	1	-360	360;
    12	16	0.0945	0.1987	0	9900	0	0	0	0	1	-360	360;
    14	15	0.221	0.1997	0	9900	0	0	0	0	1	-360	360;
    16	17	0.0524	0.1923	0	9900	0	0	0	0	1	-360	360;
    15	18	0.1073	0.2185	0	9900	0	0	0	0	1	-360	360;
    18	19	0.0639	0.1292	0	9900	0	0	0	0	1	-360	360;
    19	20	0.034	0.068	0	9900	0	0	0	0	1	-360	360;
    10	20	0.0936	0.209	0	9900	0	0	0	0	1	-360	360;
    10	17	0.0324	0.0845	0	9900	0	0	0	0	1	-360	360;
    10	21	0.0348	0.0749	0	9900	0	0	0	0	1	-360	360;
    10	22	0.0727	0.1499	0	9900	0	0	0	0	1	-360	360;
    21	22	0.0116	0.0236	0	9900	0	0	0	0	1	-360	360;
    15	23	0.1	0.202	0	9900	0	0	0	0	1	-360	360;
    22	24	0.115	0.179	0	9900	0	0	0	0	1	-360	360;
    23	24	0.132	0.27	0	9900	0	0	0	0	1	-360	360;
    24	25	0.1885	0.3292	0	9900	0	0	0	0	1	-360	360;
    25	26	0.2544	0.38	0	9900	0	0	0	0	1	-360	360;
    25	27	0.1093	0.2087	0	9900	0	0	0	0	1	-360	360;
    28	27	0	0.396	0	9900	0	0	0.968	0	1	-360	360;
    27	29	0.2198	0.4153	0	9900	0	0	0	0	1	-360	360;
    27	30	0.3202	0.6027	0	9900	0	0	0	0	1	-360	360;
    29	30	0.2399	0.4533	0	9900	0	0	0	0	1	-360	360;
    8	28	0.0636	0.2	0.0428	9900	0	0	0	0	1	-360	360;
    6	28	0.0169	0.0599	0.013	9900	0	0	0	0	1	-360	360;
    %区域2
    31	32	0.0192	0.0575	0.0528	9900	0	0	0	0	1	-360	360;
    31	33	0.0452	0.1652	0.0408	9900	0	0	0	0	1	-360	360;
    32	34	0.057	0.1737	0.0368	9900	0	0	0	0	1	-360	360;
    33	34	0.0132	0.0379	0.0084	9900	0	0	0	0	1	-360	360;
    32	35	0.0472	0.1983	0.0418	9900	0	0	0	0	1	-360	360;
    32	36	0.0581	0.1763	0.0374	9900	0	0	0	0	1	-360	360;
    34	36	0.0119	0.0414	0.009	9900	0	0	0	0	1	-360	360;
    35	37	0.046	0.116	0.0204	9900	0	0	0	0	1	-360	360;
    36	37	0.0267	0.082	0.017	9900	0	0	0	0	1	-360	360;
    36	38	0.012	0.042	0.009	9900	0	0	0	0	1	-360	360;
    36	39	0	0.208	0	9900	0	0	0.978	0	1	-360	360;
    36	40	0	0.556	0	9900	0	0	0.969	0	1	-360	360;
    39	41	0	0.208	0	9900	0	0	0	0	1	-360	360;
    39	40	0	0.11	0	9900	0	0	0	0	1	-360	360;
    34	42	0	0.256	0	9900	0	0	0.932	0	1	-360	360;
    42	43	0	0.14	0	9900	0	0	0	0	1	-360	360;
    42	44	0.1231	0.2559	0	9900	0	0	0	0	1	-360	360;
    42	45	0.0662	0.1304	0	9900	0	0	0	0	1	-360	360;
    42	46	0.0945	0.1987	0	9900	0	0	0	0	1	-360	360;
    44	45	0.221	0.1997	0	9900	0	0	0	0	1	-360	360;
    46	47	0.0524	0.1923	0	9900	0	0	0	0	1	-360	360;
    45	48	0.1073	0.2185	0	9900	0	0	0	0	1	-360	360;
    48	49	0.0639	0.1292	0	9900	0	0	0	0	1	-360	360;
    49	50	0.034	0.068	0	9900	0	0	0	0	1	-360	360;
    40	50	0.0936	0.209	0	9900	0	0	0	0	1	-360	360;
    40	47	0.0324	0.0845	0	9900	0	0	0	0	1	-360	360;
    40	51	0.0348	0.0749	0	9900	0	0	0	0	1	-360	360;
    40	52	0.0727	0.1499	0	9900	0	0	0	0	1	-360	360;
    51	52	0.0116	0.0236	0	9900	0	0	0	0	1	-360	360;
    45	53	0.1	0.202	0	9900	0	0	0	0	1	-360	360;
    52	54	0.115	0.179	0	9900	0	0	0	0	1	-360	360;
    53	54	0.132	0.27	0	9900	0	0	0	0	1	-360	360;
    54	55	0.1885	0.3292	0	9900	0	0	0	0	1	-360	360;
    55	56	0.2544	0.38	0	9900	0	0	0	0	1	-360	360;
    55	57	0.1093	0.2087	0	9900	0	0	0	0	1	-360	360;
    58	57	0	0.396	0	9900	0	0	0.968	0	1	-360	360;
    57	59	0.2198	0.4153	0	9900	0	0	0	0	1	-360	360;
    57	60	0.3202	0.6027	0	9900	0	0	0	0	1	-360	360;
    59	60	0.2399	0.4533	0	9900	0	0	0	0	1	-360	360;
    38	58	0.0636	0.2	0.0428	9900	0	0	0	0	1	-360	360;
    36	58	0.0169	0.0599	0.013	9900	0	0	0	0	1	-360	360;
    %区域3
    61	62	0.0192	0.0575	0.0528	9900	0	0	0	0	1	-360	360;
    61	63	0.0452	0.1652	0.0408	9900	0	0	0	0	1	-360	360;
    62	64	0.057	0.1737	0.0368	9900	0	0	0	0	1	-360	360;
    63	64	0.0132	0.0379	0.0084	9900	0	0	0	0	1	-360	360;
    62	65	0.0472	0.1983	0.0418	9900	0	0	0	0	1	-360	360;
    62	66	0.0581	0.1763	0.0374	9900	0	0	0	0	1	-360	360;
    64	66	0.0119	0.0414	0.009	9900	0	0	0	0	1	-360	360;
    65	67	0.046	0.116	0.0204	9900	0	0	0	0	1	-360	360;
    66	67	0.0267	0.082	0.017	9900	0	0	0	0	1	-360	360;
    66	68	0.012	0.042	0.009	9900	0	0	0	0	1	-360	360;
    66	69	0	0.208	0	9900	0	0	0.978	0	1	-360	360;
    66	70	0	0.556	0	9900	0	0	0.969	0	1	-360	360;
    69	71	0	0.208	0	9900	0	0	0	0	1	-360	360;
    69	70	0	0.11	0	9900	0	0	0	0	1	-360	360;
    64	72	0	0.256	0	9900	0	0	0.932	0	1	-360	360;
    72	73	0	0.14	0	9900	0	0	0	0	1	-360	360;
    72	74	0.1231	0.2559	0	9900	0	0	0	0	1	-360	360;
    72	75	0.0662	0.1304	0	9900	0	0	0	0	1	-360	360;
    72	76	0.0945	0.1987	0	9900	0	0	0	0	1	-360	360;
    74	75	0.221	0.1997	0	9900	0	0	0	0	1	-360	360;
    76	77	0.0524	0.1923	0	9900	0	0	0	0	1	-360	360;
    75	78	0.1073	0.2185	0	9900	0	0	0	0	1	-360	360;
    78	79	0.0639	0.1292	0	9900	0	0	0	0	1	-360	360;
    79	80	0.034	0.068	0	9900	0	0	0	0	1	-360	360;
    70	80	0.0936	0.209	0	9900	0	0	0	0	1	-360	360;
    70	77	0.0324	0.0845	0	9900	0	0	0	0	1	-360	360;
    70	81	0.0348	0.0749	0	9900	0	0	0	0	1	-360	360;
    70	82	0.0727	0.1499	0	9900	0	0	0	0	1	-360	360;
    81	82	0.0116	0.0236	0	9900	0	0	0	0	1	-360	360;
    75	83	0.1	0.202	0	9900	0	0	0	0	1	-360	360;
    82	84	0.115	0.179	0	9900	0	0	0	0	1	-360	360;
    83	84	0.132	0.27	0	9900	0	0	0	0	1	-360	360;
    84	85	0.1885	0.3292	0	9900	0	0	0	0	1	-360	360;
    85	86	0.2544	0.38	0	9900	0	0	0	0	1	-360	360;
    85	87	0.1093	0.2087	0	9900	0	0	0	0	1	-360	360;
    88	87	0	0.396	0	9900	0	0	0.968	0	1	-360	360;
    87	89	0.2198	0.4153	0	9900	0	0	0	0	1	-360	360;
    87	90	0.3202	0.6027	0	9900	0	0	0	0	1	-360	360;
    89	90	0.2399	0.4533	0	9900	0	0	0	0	1	-360	360;
    68	88	0.0636	0.2	0.0428	9900	0	0	0	0	1	-360	360;
    66	88	0.0169	0.0599	0.013	9900	0	0	0	0	1	-360	360;
    %联络线
    24 54 0	0.256	0	9900	0	0	0.932	0	1	-360	360;
    54 84 0	0.256	0	9900	0	0	0.932	0	1	-360	360;
    84 24 0	0.256	0	9900	0	0	0.932	0	1	-360	360;
    ];

Fmax0=[1,2,60;1,3,75;2,4,94;3,4,79;2,5,250;2,6,115;4,6,48;5,7,250;6,7,200;6,8,80;6,9,115;6,10,115;9,11,120;9,10,115;4,12,100;12,13,120;12,14,27;12,15,64;12,16,30;14,15,34;16,17,35;15,18,30;18,19,32;19,20,35;10,20,34;10,17,26;10,21,78;10,22,113;21,22,60;15,23,44;22,24,76;23,24,48;24,25,49;25,26,28;25,27,29;28,27,49;27,29,31;27,30,32;29,30,35;8,28,80;6,28,62;31,32,60;31,33,75;32,34,100;33,34,66;32,35,250;32,36,132;34,36,72;35,37,250;36,37,200;36,38,80;36,39,100;36,40,115;39,41,120;39,40,115;34,42,100;42,43,120;42,44,26;42,45,60;42,46,28;44,45,26;46,47,34;45,48,35;48,49,35;49,50,29;40,50,27;40,47,29;40,51,80;40,52,113;51,52,79;45,53,68;52,54,120;53,54,67;54,55,49;55,56,31;55,57,58;58,57,62;57,59,34;57,60,29;59,60,32;38,58,80;36,58,64;61,62,60;61,63,75;62,64,87;63,64,74;62,65,250;62,66,146;64,66,64;65,67,250;66,67,200;66,68,79;66,69,100;66,70,115;69,71,120;69,70,115;64,72,100;72,73,120;72,74,28;72,75,64;72,76,28;74,75,34;76,77,33;75,78,33;78,79,30;79,80,35;70,80,32;70,77,29;70,81,61;70,82,107;81,82,50;75,83,48;82,84,85;83,84,49;84,85,46;85,86,32;85,87,43;88,87,53;87,89,27;87,90,34;89,90,33;68,88,80;66,88,79;24,54,75;54,84,75;84,24,75];
branch=zeros(size(branch_temp,1),12);
branch(:,1:5)=branch_temp(:,1:5);
branch(:,6)=Fmax0(:,3);
branch(:,7)=branch_temp(:,9);
branch(:,8:9)=branch_temp(:,10:11);
branch(:,10)=[0.305000000000000;0.304000000000000;0.303191489361702;0.303797468354430;0.301200000000000;0.302608695652174;0.306250000000000;0.301200000000000;0.301500000000000;0.303750000000000;0.302608695652174;0.302608695652174;0.302500000000000;0.302608695652174;0.303000000000000;0.302500000000000;0.311111111111111;0.304687500000000;0.310000000000000;0.308823529411765;0.308571428571429;0.310000000000000;0.309375000000000;0.308571428571429;0.308823529411765;0.311538461538462;0.303846153846154;0.302654867256637;0.305000000000000;0.306818181818182;0.303947368421053;0.306250000000000;0.306122448979592;0.310714285714286;0.310344827586207;0.306122448979592;0.309677419354839;0.309375000000000;0.308571428571429;0.303750000000000;0.304838709677419;0.305000000000000;0.304000000000000;0.303000000000000;0.304545454545455;0.301200000000000;0.302272727272727;0.304166666666667;0.301200000000000;0.301500000000000;0.303750000000000;0.303000000000000;0.302608695652174;0.302500000000000;0.302608695652174;0.303000000000000;0.302500000000000;0.311538461538462;0.305000000000000;0.310714285714286;0.311538461538462;0.308823529411765;0.308571428571429;0.308571428571429;0.310344827586207;0.311111111111111;0.310344827586207;0.303750000000000;0.302654867256637;0.303797468354430;0.304411764705882;0.302500000000000;0.304477611940299;0.306122448979592;0.309677419354839;0.305172413793103;0.304838709677419;0.308823529411765;0.310344827586207;0.309375000000000;0.303750000000000;0.304687500000000;0.305000000000000;0.304000000000000;0.303448275862069;0.304054054054054;0.301200000000000;0.302054794520548;0.304687500000000;0.301200000000000;0.301500000000000;0.303797468354430;0.303000000000000;0.302608695652174;0.302500000000000;0.302608695652174;0.303000000000000;0.302500000000000;0.310714285714286;0.304687500000000;0.310714285714286;0.308823529411765;0.309090909090909;0.309090909090909;0.310000000000000;0.308571428571429;0.309375000000000;0.310344827586207;0.304918032786885;0.302803738317757;0.306000000000000;0.306250000000000;0.303529411764706;0.306122448979592;0.306521739130435;0.309375000000000;0.306976744186047;0.305660377358491;0.311111111111111;0.308823529411765;0.309090909090909;0.303750000000000;0.303797468354430;0.304000000000000;0.304000000000000;0.304000000000000];%       10  Lamda, Failure Rate
branch(:,11)=[16;17.5000000000000;19.4000000000000;17.9000000000000;35;21.5000000000000;14.8000000000000;35;30;18;21.5000000000000;21.5000000000000;22;21.5000000000000;20;22;12.7000000000000;16.4000000000000;13;13.4000000000000;13.5000000000000;13;13.2000000000000;13.5000000000000;13.4000000000000;12.6000000000000;17.8000000000000;21.3000000000000;16;14.4000000000000;17.6000000000000;14.8000000000000;14.9000000000000;12.8000000000000;12.9000000000000;14.9000000000000;13.1000000000000;13.2000000000000;13.5000000000000;18;16.2000000000000;16;17.5000000000000;20;16.6000000000000;35;23.2000000000000;17.2000000000000;35;30;18;20;21.5000000000000;22;21.5000000000000;20;22;12.6000000000000;16;12.8000000000000;12.6000000000000;13.4000000000000;13.5000000000000;13.5000000000000;12.9000000000000;12.7000000000000;12.9000000000000;18;21.3000000000000;17.9000000000000;16.8000000000000;22;16.7000000000000;14.9000000000000;13.1000000000000;15.8000000000000;16.2000000000000;13.4000000000000;12.9000000000000;13.2000000000000;18;16.4000000000000;16;17.5000000000000;18.7000000000000;17.4000000000000;35;24.6000000000000;16.4000000000000;35;30;17.9000000000000;20;21.5000000000000;22;21.5000000000000;20;22;12.8000000000000;16.4000000000000;12.8000000000000;13.4000000000000;13.3000000000000;13.3000000000000;13;13.5000000000000;13.2000000000000;12.9000000000000;16.1000000000000;20.7000000000000;15;14.8000000000000;18.5000000000000;14.9000000000000;14.6000000000000;13.2000000000000;14.3000000000000;15.3000000000000;12.7000000000000;13.4000000000000;13.3000000000000;18;17.9000000000000;17.5000000000000;17.5000000000000;17.5000000000000];%       11  MTTF, Repair duration
branch(:,12)=zeros(size(branch_temp,1),1);
branch(:,13) = 1-8760./(branch(:,10).*branch(:,11)+8760);

rate = 1.00;
bus(:,3) = rate.*bus(:,3);
bus(:,4) = rate.*bus(:,4);
gen(:,2) = rate.*gen(:,2);
gen(:,3) = rate.*gen(:,3);
gen(:,9) = rate.*gen(:,9);
gen(:,4) = rate.*gen(:,4);
gen(:,5) = rate.*gen(:,5);
gen(:,10) = rate.*gen(:,10);


bus(:,13:32) = 0; 
busPmax = zeros(size(bus,1),1);
busPmin = zeros(size(bus,1),1);
busPG = zeros(size(bus,1),1);
busQmax = zeros(size(bus,1),1);
busQmin = zeros(size(bus,1),1);
busQG = zeros(size(bus,1),1);
ref = find(bus(:,2) == 3);
pv = find(bus(:,2) == 2);
pq = find(bus(:,2) == 1);


for i=1:size(bus,1)
    genindex = find(gen(:,1) == i);
    if(isempty(genindex) ~= 1)
        busPmax(i) = sum(gen(genindex,2));
        busPmin(i) = sum(gen(genindex,3));
        busPG(i)   = sum(gen(genindex,9));
        busQmax(i) = sum(gen(genindex,4));
        busQmin(i) = sum(gen(genindex,5));%%because the Qmin of the generator can be negative
        busQG(i)   = sum(gen(genindex,10));
    else
        busPmax(i) = 0;
        busPmin(i) = 0;
        busQmax(i) = 0;
        busQmin(i) = 0;
        busPG(i) = 0;
        busQG(i) = 0;
    end       
end   

bus(:,13) = busPmax;
bus(:,14) = busPmin;
bus(:,15) = busQmax;
bus(:,16) = busQmin;
bus(:,17) = busPG;
bus(:,18) = busQG;



branch(:,14:23) = 0.0;
PBase = prod(1-gen(:,11));
PBase = PBase * prod(1-branch(:,13));
PFBase = sum(gen(:,7));
PFBase = PFBase + sum(branch(:,10));




