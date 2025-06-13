within Absolut.FluidBased.Dynamic.LabValidation.Data;
model sBSc_1m_Cfg0_20220804

// file: sBSc_1m_Cfg0_20220804_T59_corrected_fromstart.txt

Modelica.Units.SI.MassFlowRate m_dot1 = Vd_HT_clamp85 * Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.density(           Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.setState_pTX(           200000,
        T_HT_RL_pt84));

Modelica.Units.SI.HeatFlowRate Q_genT83 = m_dot1*Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.specificHeatCapacityCp(
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.setState_pTX(           200000, (T_HT_VL_pt83 +
        T_HeizRL_Wegra118)/2))*(T_HT_VL_pt83 - T_HeizRL_Wegra118);

Modelica.Units.SI.HeatFlowRate Q_eva = m_dot1*Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.specificHeatCapacityCp(
        Absolut.FluidBased.Dynamic.LabValidation.ThermalOil.setState_pTX(           200000, (T_WT_HT_OUT_pt138 + T_WRG_in_pt79)/2))*(T_WT_HT_OUT_pt138 - T_WRG_in_pt79);

Modelica.Units.SI.MassFlowRate m_dot2 = Vd_MT_clamp124 * Modelica.Media.Water.WaterIF97_R1ph.density_pT(200000, T_KuehlRL_Wegra120);
Modelica.Units.SI.HeatFlowRate Q_con = m_dot2 * Modelica.Media.Water.WaterIF97_R1ph.specificHeatCapacityCp(Modelica.Media.Water.WaterIF97_R1ph.setState_pT(200000, (
        T_KuehlRL_Wegra120 + T_MT_ABS_Out_pt102)/2))*(T_KuehlRL_Wegra120 - T_MT_ABS_Out_pt102);
Modelica.Units.SI.HeatFlowRate Q_abs = m_dot2 * Modelica.Media.Water.WaterIF97_R1ph.specificHeatCapacityCp(Modelica.Media.Water.WaterIF97_R1ph.setState_pT(200000, (
        T_MT_ABS_Out_pt102 + T_MT_return_wmz59)/2))*(T_MT_ABS_Out_pt102 - T_MT_return_wmz59);

        Modelica.Units.SI.HeatFlowRate Q_balance = Q_in - Q_out;
        Modelica.Units.SI.HeatFlowRate Q_in = Q_genT83 +  Q_eva;
        Modelica.Units.SI.HeatFlowRate Q_out = Q_abs + Q_con;
        Modelica.Units.SI.Energy E_in_minus_out( start=0);

// Calculate additional points... i.e. estimations.

  parameter Modelica.Units.SI.MassFraction X_LiBr_genT121_start = 1 - Absolut.Media.LiBrH2O.X_Tp(    T_Loesungsmittel_Wegra121_start,p_KondensatorGenerator_Wegra125_start);
  parameter Modelica.Units.SI.MassFraction X_LiBr_genT99_start = 1 - Absolut.Media.LiBrH2O.X_Tp(    T_GEN_Out_pt99_start,p_KondensatorGenerator_Wegra125_start);
  parameter Modelica.Units.SI.MassFraction X_LiBr_abs_start = 1 - Absolut.Media.LiBrH2O.X_Tp(    T_ABS_Out_pt101_start,p_VerdampferAbsorber_Wegra126_start);

  Modelica.Units.SI.MassFraction X_LiBr_genT121 = 1 - Absolut.Media.LiBrH2O.X_Tp(    T_Loesungsmittel_Wegra121,p_KondensatorGenerator_Wegra125);
  Modelica.Units.SI.MassFraction X_LiBr_genT99 = 1 - Absolut.Media.LiBrH2O.X_Tp(    T_GEN_Out_pt99,p_KondensatorGenerator_Wegra125);
  Modelica.Units.SI.MassFraction X_LiBr_abs = 1 - Absolut.Media.LiBrH2O.X_Tp(    T_ABS_Out_pt101,p_VerdampferAbsorber_Wegra126);

parameter String versuchsnummer = "sBSc_1m_Cfg0_20220804";
//

//
parameter Real SSV_start = 2.10 "";
parameter Modelica.Units.SI.Temperature SekT_start = 43.83  + 273.15 "degC";
parameter Real GSV1_start = 2.92 "";
parameter Real GSV2_start = 2.92 "";
parameter Modelica.Units.SI.Temperature PrimaerT_start = 128.96  + 273.15 "degC";
parameter Modelica.Units.SI.TemperatureDifference UK1_start = 8.186 "K";
parameter Modelica.Units.SI.TemperatureDifference UK2_start = 8.199 "K";
parameter Modelica.Units.SI.Pressure  p_KaelteSek_AI0_start = 0.01 * 100000
                                                                           "0bar to Pa";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_KaelteSek_AI1_start = -0.31  * 1/3600/1000
                                                                                         "1 l/h converted to m3/s";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_KaelteSek_Soll2_start = 0  * 1/3600/1000
                                                                                       "2 l/h converted to m3/s";
parameter Modelica.Units.SI.Temperature  T_KaelteSek_WT_in_pt3_start = 24.16  + 273.15 "3 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaelteSek_WT_out_pt4_start = 25.18  + 273.15 "4 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaelteSek_WT_out_Soll5_start = 0  + 273.15 "5 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaelteSek_HST_in_pt6_start = 25.29  + 273.15 "6 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaelteSek_HST_out_pt7_start = 24.48  + 273.15 "7 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaelteSek_HST_out_Soll8_start = 0  + 273.15 "8 degC converted to K";
parameter Modelica.Units.SI.Energy  Q_KaelteSek_calc9_start = 0  * 3.6e+6
                                                                         "9 kWh to Joules";
parameter Modelica.Units.SI.Power  P_KaelteSek_calc10_start = 3.9  "10 W";
parameter Modelica.Units.SI.Energy  Q_KaelteSek_WT_calc11_start = 0  * 3.6e+6
                                                                             "11 kWh to Joules";
parameter Modelica.Units.SI.Power  P_KaelteSek_WT_calc12_start = -0.4  "12 W";
parameter Modelica.Units.SI.Energy  Q_KaelteSek_HST_calc13_start = 0  * 3.6e+6
                                                                              "13 kWh to Joules";
parameter Modelica.Units.SI.Power  P_KaelteSek_HST_calc14_start = 0.3  "14 W";
parameter Modelica.Units.SI.Energy  Q_KaelteSek_HST_MBUS15_start = 692.022  * 3.6e+6
                                                                                    "15 kWh to Joules";
parameter Modelica.Units.SI.Power  P_KaelteSek_HST_MBUS16_start = 0  "16 W";
parameter Real  PU_KaelteSek17_start = 0  "17 %";
parameter Real  HST_KaelteSek18_start = 0  "18 %";
parameter Real  PU_KaeltePri19_start = 0  "19 %";
parameter Real  VEN_KaeltePri_A20_start = 0  "20 %";
parameter Real  VEN_KaeltePri_B21_start = 0  "21 %";
parameter Modelica.Units.SI.Energy  Q_KaeltePri_wmz22_start = 1018  * 3.6e+6
                                                                            "22 kWh to Joules";
parameter Modelica.Units.SI.Volume  V_KaeltePri_wmz23_start = 1495.13  "23 m3";
parameter Modelica.Units.SI.Temperature  T_KaeltePri_in_wmz24_start = 25.61  + 273.15 "24 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaeltePri_out_wmz25_start = 26.45  + 273.15 "25 degC converted to K";
parameter Modelica.Units.SI.Power  P_KaeltePri_wmz26_start = 0  "26 W";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_KaeltePri_wmz27_start = 0  * 1/3600/1000
                                                                                       "27 l/h converted to m3/s";
parameter Modelica.Units.SI.Pressure  p_WaermeSek_AI28_start = 1.59  * 100000
                                                                             "28bar to Pa";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_WaermeSek_AI29_start = -0.03  * 1/3600/1000
                                                                                          "29 l/h converted to m3/s";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_WaermeSek_Soll30_start = 0  * 1/3600/1000
                                                                                        "30 l/h converted to m3/s";
parameter Modelica.Units.SI.Temperature  T_WaermeSek_WT_in_pt31_start = 24.52  + 273.15 "31 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WaermeSek_WT_out_pt32_start = 25.18  + 273.15 "32 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WaermeSek_WT_out_Soll33_start = 0  + 273.15 "33 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WaermeSek_HST_in_pt34_start = 25.77  + 273.15 "34 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WaermeSek_HST_out_pt35_start = 25.29  + 273.15 "35 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WaermeSek_HST_out_Soll36_start = 0  + 273.15 "36 degC converted to K";
parameter Modelica.Units.SI.Energy  Q_WaermeSek_calc37_start = 0  * 3.6e+6
                                                                          "37 kWh to Joules";
parameter Modelica.Units.SI.Power  P_WaermeSek_calc38_start = -0.1  "38 W";
parameter Modelica.Units.SI.Energy  Q_WaermeSek_WT_calc39_start = 0  * 3.6e+6
                                                                             "39 kWh to Joules";
parameter Modelica.Units.SI.Power  P_WaermeSek_WT_calc40_start = -0.1  "40 W";
parameter Modelica.Units.SI.Energy  Q_WaermeSek_HST_calc41_start = 0  * 3.6e+6
                                                                              "41 kWh to Joules";
parameter Modelica.Units.SI.Power  P_WaermeSek_HST_calc42_start = 0  "42 W";
parameter Modelica.Units.SI.Energy  Q_WaermeSek_HST_MBUS43_start = 1166.548  * 3.6e+6
                                                                                     "43 kWh to Joules";
parameter Modelica.Units.SI.Power  P_WaermeSek_HST_MBUS44_start = 0  "44 W";
parameter Real  PU_WaermeSek45_start = 0  "45 %";
parameter Real  HST_WaermeSek46_start = 0  "46 %";
parameter Real  PU_WaermePri47_start = 0  "47 %";
parameter Real  VEN_WaermePri_A48_start = 0  "48 %";
parameter Real  VEN_WaermePri_B49_start = 0  "49 %";
parameter Modelica.Units.SI.Energy  Q_WaermePri_wmz50_start = 714  * 3.6e+6
                                                                           "50 kWh to Joules";
parameter Modelica.Units.SI.Volume  V_WaermePri_wmz51_start = 1324.01  "51 m3";
parameter Modelica.Units.SI.Temperature  T_WaermePri_in_wmz52_start = 26.29  + 273.15 "52 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WaermePri_out_wmz53_start = 25.95  + 273.15 "53 degC converted to K";
parameter Modelica.Units.SI.Power  P_WaermePri_wmz54_start = 0  "54 W";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_WaermePri_wmz55_start = 0  * 1/3600/1000
                                                                                       "55 l/h converted to m3/s";
parameter Modelica.Units.SI.Energy  Q_MT_wmz56_start = 1828  * 3.6e+6
                                                                     "56 kWh";
parameter Modelica.Units.SI.Volume  V_MT_wmz57_start = 137.52  "57 m3";
parameter Modelica.Units.SI.Temperature  T_MT_flow_wmz58_start = 54.83  + 273.15 "58 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_MT_return_wmz59_start = 43.81  + 273.15 "59 degC converted to K";
parameter Modelica.Units.SI.Power  P_MT_wmz60_start = 9550  "60 W";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_MT_wmz61_start = 757  * 1/3600/1000
                                                                                  "61 l/h converted to m3/s";
parameter Modelica.Units.SI.Energy  E_HT_ECnt62_start = 2624.3  * 3.6e+6
                                                                        "62 kWh to Joules";
parameter Modelica.Units.SI.Power  P_HT_ECnt63_start = 11677  "63 W";
parameter Modelica.Units.SI.Energy  E_SWP_ECnt64_start = -21474836.48  * 3.6e+6
                                                                               "64 kWh to Joules";
parameter Modelica.Units.SI.Power  P_SWP_ECnt65_start = -21474836.48  "65 W";
parameter Real  Reserve_6666_start = 0  "66 -";
parameter Real  VEN_WT67_start = 76  "67 %";
parameter Modelica.Units.SI.Pressure  p_MT68_start = 2  * 100000
                                                                "68bar to Pa";
parameter Modelica.Units.SI.Pressure  p_HT69_start = 1.88  * 100000
                                                                   "69bar to Pa";
parameter Modelica.Units.SI.Temperature  T_Erd_in_pt70_start = 27.646  + 273.15 "70 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Erd_out_pt71_start = 39.975  + 273.15 "71 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Erd_MT_in_pt72_start = 51.446  + 273.15 "72 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Erd_MT_out_pt73_start = 27.724  + 273.15 "73 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_PU_MT_out_pt74_start = 44.023  + 273.15 "74 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Not_in_pt75_start = 50.378  + 273.15 "75 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Not_out_pt76_start = 50.634  + 273.15 "76 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Not_MT_in_pt77_start = 52.103  + 273.15 "77 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Not_MT_out_pt78_start = 52.899  + 273.15 "78 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WRG_in_pt79_start = 35.648  + 273.15 "79 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WRG_out_pt80_start = 54.617  + 273.15 "80 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WRG_MT_in_pt81_start = 54.726  + 273.15 "81 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WRG_MT_out_pt82_start = 52.262  + 273.15 "82 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_HT_VL_pt83_start = 124.832  + 273.15 "83 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_HT_RL_pt84_start = 53.385  + 273.15 "84 degC converted to K";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_HT_clamp85_start = 259.41  * 1/3600/1000
                                                                                       "85 l/h to be converted to m3/s";
parameter Real  HE_HT86_start = 52  "86 %";
parameter Real  PU_Erd87_start = 100  "87 %";
parameter Real  PU_MT88_start = 70  "88 %";
parameter Real  PU_HT89_start = 49  "89 %";
parameter Real  VEN_MT_Erd90_start = 60  "90 %";
parameter Real  VEN_MT_WRG91_start = 0  "91 %";
parameter Real  VEN_Not92_start = 0  "92 %";
parameter Real  SWP_On93_start = 100  "93 %";
parameter Real  PU_NT_Freigabe94_start = 1  "94 %";
parameter Real  PU_HT_Freigabe95_start = 1  "95 %";
parameter Real  PU_MT_Freigabe96_start = 1  "96 %";
parameter Real  DI_Reserve97_start = 0  "97 %";
parameter Modelica.Units.SI.Temperature  T_GEN_In_pt98_start = 82.225  + 273.15 "98 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_GEN_Out_pt99_start = 87.495  + 273.15 "99 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_ABS_In_pt100_start = 61.891  + 273.15 "100 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_ABS_Out_pt101_start = 56.987  + 273.15 "101 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_MT_ABS_Out_pt102_start = 57.743  + 273.15 "102 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_VER_Kreis_pt103_start = 35.421  + 273.15 "103 degC converted to K";
parameter Real  STOP_Last_Ina104_start = 0  "104 %";
parameter Real  Betriebsart_Wegra105_start = 0  "105 -";
parameter Real  PU_MT_Wegra106_start = 100  "106 %";
parameter Real  PU_HT_Wegra107_start = 100  "107 %";
parameter Real  PU_NT_Wegra108_start = 100  "108 %";
parameter Real  Backup_Wegra109_start = 0  "109 %";
parameter Real  Stoerung_Wegra110_start = 0  "110 %";
parameter Real  FAN_Kuehlturm_Wegra111_start = 0  "111 %";
parameter Real  MI_Kaeltetraeger_Wegra112_start = 0  "112 %";
parameter Real  MI_Heizwasserwasser_Wegra113_start = 0  "113 %";
parameter Real  MI_Kuehlwasser_Wegra114_start = 0  "114 %";
parameter Modelica.Units.SI.Temperature  T_HeizVL_Wegra115_start = 128.96  + 273.15 "115 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaltVL_Wegra116_start = 35.22  + 273.15 "116 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KuehlVL_Wegra117_start = 43.18  + 273.15 "117 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_HeizRL_Wegra118_start = 84.45  + 273.15 "118 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KaltRL_Wegra119_start = 42.36  + 273.15 "119 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_KuehlRL_Wegra120_start = 60.02  + 273.15 "120 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Loesungsmittel_Wegra121_start = 87.98  + 273.15 "121 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_MT_Soll_Wegra122_start = 57.41  + 273.15 "122 degC converted to K";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_MT_mid123_start = 513.827  * 1/3600/1000
                                                                                       "123 l/h converted to m3/s";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_MT_clamp124_start = 244.645  * 1/3600/1000
                                                                                         "124 l/h converted to m3/s";
parameter Modelica.Units.SI.Pressure  p_KondensatorGenerator_Wegra125_start = 209.16  * 100 "125 mbar to be converted to Pa";
parameter Modelica.Units.SI.Pressure  p_VerdampferAbsorber_Wegra126_start = 55.71  * 100 "126 mbar to be converted to Pa";
parameter Real  Start_Kuehlen_Wegra127_start = 0  "127 %";
parameter Real  Start_KuehlenOhneAbsorber_Wegra128_start = 0  "128 %";
parameter Real  LockSum_PU_KSek129_start = 0  "129 ";
parameter Real  LockSum_HST_KSek130_start = 0  "130 ";
parameter Real  LockSum_PU_WSek131_start = 0  "131 ";
parameter Real  LockSum_HST_WSek132_start = 0  "132 ";
parameter Real  LockSum_PU_MT133_start = 0  "133 ";
parameter Real  LockSum_PU_Erd134_start = 0  "134 ";
parameter Real  LockSum_PU_HT135_start = 0  "135 ";
parameter Real  LockSum_HE_HT136_start = 0  "136 ";
parameter Modelica.Units.SI.Temperature  T_WT_HT_IN_pt137_start = 84.584  + 273.15 "137 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WT_HT_OUT_pt138_start = 43.812  + 273.15 "138 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WT_MT_IN_pt139_start = 43.834  + 273.15 "139 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_WT_MT_OUT_pt140_start = 54.059  + 273.15 "140 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_HE_HT_aussen141_start = 203.182  + 273.15 "141 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Misch_MT_pt142_start = 55.146  + 273.15 "142 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Reserve_143143_start =  273.15 "143 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Reserve_144144_start =  273.15 "144 degC converted to K";
parameter Modelica.Units.SI.Energy  Q_Rekup_wmz145_start = 1120  * 3.6e+6
                                                                         "145 kWh to Joules";
parameter Modelica.Units.SI.Volume  V_Rekup_wmz146_start = 1171.01  "146 m3";
parameter Modelica.Units.SI.Temperature  T_Rekup_flow_wmz147_start = 54.92  + 273.15 "147 degC converted to K";
parameter Modelica.Units.SI.Temperature  T_Rekup_return_wmz148_start = 51.97  + 273.15 "148 degC converted to K";
parameter Modelica.Units.SI.Power  P_Rekup_wmz149_start = 2500  "149 W";
parameter Modelica.Units.SI.VolumeFlowRate  Vd_Rekup_wmz150_start = 743  * 1/3600/1000
                                                                                      "150 l/h converted to m3/s";

//
Real SSV= datareader.y[ 1]  "";
Modelica.Units.SI.Temperature SekT= datareader.y[ 2]  "degC";
Real GSV1= datareader.y[ 3]  "";
Real GSV2= datareader.y[ 4]  "";
Modelica.Units.SI.Temperature PrimaerT= datareader.y[ 5]  "degC";
Modelica.Units.SI.TemperatureDifference UK1= datareader.y[ 6]  "K";
Modelica.Units.SI.TemperatureDifference UK2= datareader.y[ 7]  "K";
Modelica.Units.SI.Pressure  p_KaelteSek_AI0= datareader.y[ 8]  * 100000
                                                                       "0bar to Pa";
Modelica.Units.SI.VolumeFlowRate  Vd_KaelteSek_AI1= datareader.y[ 9]  * 1/3600/1000
                                                                                   "1 l/h converted to m3/s";
Modelica.Units.SI.VolumeFlowRate  Vd_KaelteSek_Soll2= datareader.y[ 10]  * 1/3600/1000
                                                                                      "2 l/h converted to m3/s";
Modelica.Units.SI.Temperature  T_KaelteSek_WT_in_pt3= datareader.y[ 11]  + 273.15 "3 degC converted to K";
Modelica.Units.SI.Temperature  T_KaelteSek_WT_out_pt4= datareader.y[ 12]  + 273.15 "4 degC converted to K";
Modelica.Units.SI.Temperature  T_KaelteSek_WT_out_Soll5= datareader.y[ 13]  + 273.15 "5 degC converted to K";
Modelica.Units.SI.Temperature  T_KaelteSek_HST_in_pt6= datareader.y[ 14]  + 273.15 "6 degC converted to K";
Modelica.Units.SI.Temperature  T_KaelteSek_HST_out_pt7= datareader.y[ 15]  + 273.15 "7 degC converted to K";
Modelica.Units.SI.Temperature  T_KaelteSek_HST_out_Soll8= datareader.y[ 16]  + 273.15 "8 degC converted to K";
Modelica.Units.SI.Energy  Q_KaelteSek_calc9= datareader.y[ 17]  * 3.6e+6
                                                                        "9 kWh to Joules";
Modelica.Units.SI.Power  P_KaelteSek_calc10= datareader.y[ 18]  "10 W";
Modelica.Units.SI.Energy  Q_KaelteSek_WT_calc11= datareader.y[ 19]  * 3.6e+6
                                                                            "11 kWh to Joules";
Modelica.Units.SI.Power  P_KaelteSek_WT_calc12= datareader.y[ 20]  "12 W";
Modelica.Units.SI.Energy  Q_KaelteSek_HST_calc13= datareader.y[ 21]  * 3.6e+6
                                                                             "13 kWh to Joules";
Modelica.Units.SI.Power  P_KaelteSek_HST_calc14= datareader.y[ 22]  "14 W";
Modelica.Units.SI.Energy  Q_KaelteSek_HST_MBUS15= datareader.y[ 23]  * 3.6e+6
                                                                             "15 kWh to Joules";
Modelica.Units.SI.Power  P_KaelteSek_HST_MBUS16= datareader.y[ 24]  "16 W";
Real  PU_KaelteSek17= datareader.y[ 25]  "17 %";
Real  HST_KaelteSek18= datareader.y[ 26]  "18 %";
Real  PU_KaeltePri19= datareader.y[ 27]  "19 %";
Real  VEN_KaeltePri_A20= datareader.y[ 28]  "20 %";
Real  VEN_KaeltePri_B21= datareader.y[ 29]  "21 %";
Modelica.Units.SI.Energy  Q_KaeltePri_wmz22= datareader.y[ 30]  * 3.6e+6
                                                                        "22 kWh to Joules";
Modelica.Units.SI.Volume  V_KaeltePri_wmz23= datareader.y[ 31]  "23 m3";
Modelica.Units.SI.Temperature  T_KaeltePri_in_wmz24= datareader.y[ 32]  + 273.15 "24 degC converted to K";
Modelica.Units.SI.Temperature  T_KaeltePri_out_wmz25= datareader.y[ 33]  + 273.15 "25 degC converted to K";
Modelica.Units.SI.Power  P_KaeltePri_wmz26= datareader.y[ 34]  "26 W";
Modelica.Units.SI.VolumeFlowRate  Vd_KaeltePri_wmz27= datareader.y[ 35]  * 1/3600/1000
                                                                                      "27 l/h converted to m3/s";
Modelica.Units.SI.Pressure  p_WaermeSek_AI28= datareader.y[ 36]  * 100000
                                                                         "28bar to Pa";
Modelica.Units.SI.VolumeFlowRate  Vd_WaermeSek_AI29= datareader.y[ 37]  * 1/3600/1000
                                                                                     "29 l/h converted to m3/s";
Modelica.Units.SI.VolumeFlowRate  Vd_WaermeSek_Soll30= datareader.y[ 38]  * 1/3600/1000
                                                                                       "30 l/h converted to m3/s";
Modelica.Units.SI.Temperature  T_WaermeSek_WT_in_pt31= datareader.y[ 39]  + 273.15 "31 degC converted to K";
Modelica.Units.SI.Temperature  T_WaermeSek_WT_out_pt32= datareader.y[ 40]  + 273.15 "32 degC converted to K";
Modelica.Units.SI.Temperature  T_WaermeSek_WT_out_Soll33= datareader.y[ 41]  + 273.15 "33 degC converted to K";
Modelica.Units.SI.Temperature  T_WaermeSek_HST_in_pt34= datareader.y[ 42]  + 273.15 "34 degC converted to K";
Modelica.Units.SI.Temperature  T_WaermeSek_HST_out_pt35= datareader.y[ 43]  + 273.15 "35 degC converted to K";
Modelica.Units.SI.Temperature  T_WaermeSek_HST_out_Soll36= datareader.y[ 44]  + 273.15 "36 degC converted to K";
Modelica.Units.SI.Energy  Q_WaermeSek_calc37= datareader.y[ 45]  * 3.6e+6
                                                                         "37 kWh to Joules";
Modelica.Units.SI.Power  P_WaermeSek_calc38= datareader.y[ 46]  "38 W";
Modelica.Units.SI.Energy  Q_WaermeSek_WT_calc39= datareader.y[ 47]  * 3.6e+6
                                                                            "39 kWh to Joules";
Modelica.Units.SI.Power  P_WaermeSek_WT_calc40= datareader.y[ 48]  "40 W";
Modelica.Units.SI.Energy  Q_WaermeSek_HST_calc41= datareader.y[ 49]  * 3.6e+6
                                                                             "41 kWh to Joules";
Modelica.Units.SI.Power  P_WaermeSek_HST_calc42= datareader.y[ 50]  "42 W";
Modelica.Units.SI.Energy  Q_WaermeSek_HST_MBUS43= datareader.y[ 51]  * 3.6e+6
                                                                             "43 kWh to Joules";
Modelica.Units.SI.Power  P_WaermeSek_HST_MBUS44= datareader.y[ 52]  "44 W";
Real  PU_WaermeSek45= datareader.y[ 53]  "45 %";
Real  HST_WaermeSek46= datareader.y[ 54]  "46 %";
Real  PU_WaermePri47= datareader.y[ 55]  "47 %";
Real  VEN_WaermePri_A48= datareader.y[ 56]  "48 %";
Real  VEN_WaermePri_B49= datareader.y[ 57]  "49 %";
Modelica.Units.SI.Energy  Q_WaermePri_wmz50= datareader.y[ 58]  * 3.6e+6
                                                                        "50 kWh to Joules";
Modelica.Units.SI.Volume  V_WaermePri_wmz51= datareader.y[ 59]  "51 m3";
Modelica.Units.SI.Temperature  T_WaermePri_in_wmz52= datareader.y[ 60]  + 273.15 "52 degC converted to K";
Modelica.Units.SI.Temperature  T_WaermePri_out_wmz53= datareader.y[ 61]  + 273.15 "53 degC converted to K";
Modelica.Units.SI.Power  P_WaermePri_wmz54= datareader.y[ 62]  "54 W";
Modelica.Units.SI.VolumeFlowRate  Vd_WaermePri_wmz55= datareader.y[ 63]  * 1/3600/1000
                                                                                      "55 l/h converted to m3/s";
Modelica.Units.SI.Energy  Q_MT_wmz56= datareader.y[ 64]  * 3.6e+6
                                                                 "56 kWh";
Modelica.Units.SI.Volume  V_MT_wmz57= datareader.y[ 65]  "57 m3";
Modelica.Units.SI.Temperature  T_MT_flow_wmz58= datareader.y[ 66]  + 273.15 "58 degC converted to K";
Modelica.Units.SI.Temperature  T_MT_return_wmz59= datareader.y[ 67]  + 273.15 "59 degC converted to K";
Modelica.Units.SI.Power  P_MT_wmz60= datareader.y[ 68]  "60 W";
Modelica.Units.SI.VolumeFlowRate  Vd_MT_wmz61= datareader.y[ 69]  * 1/3600/1000
                                                                               "61 l/h converted to m3/s";
Modelica.Units.SI.Energy  E_HT_ECnt62= datareader.y[ 70]  * 3.6e+6
                                                                  "62 kWh to Joules";
Modelica.Units.SI.Power  P_HT_ECnt63= datareader.y[ 71]  "63 W";
Modelica.Units.SI.Energy  E_SWP_ECnt64= datareader.y[ 72]  * 3.6e+6
                                                                   "64 kWh to Joules";
Modelica.Units.SI.Power  P_SWP_ECnt65= datareader.y[ 73]  "65 W";
Real  Reserve_6666= datareader.y[ 74]  "66 -";
Real  VEN_WT67= datareader.y[ 75]  "67 %";
Modelica.Units.SI.Pressure  p_MT68= datareader.y[ 76]  * 100000
                                                               "68bar to Pa";
Modelica.Units.SI.Pressure  p_HT69= datareader.y[ 77]  * 100000
                                                               "69bar to Pa";
Modelica.Units.SI.Temperature  T_Erd_in_pt70= datareader.y[ 78]  + 273.15 "70 degC converted to K";
Modelica.Units.SI.Temperature  T_Erd_out_pt71= datareader.y[ 79]  + 273.15 "71 degC converted to K";
Modelica.Units.SI.Temperature  T_Erd_MT_in_pt72= datareader.y[ 80]  + 273.15 "72 degC converted to K";
Modelica.Units.SI.Temperature  T_Erd_MT_out_pt73= datareader.y[ 81]  + 273.15 "73 degC converted to K";
Modelica.Units.SI.Temperature  T_PU_MT_out_pt74= datareader.y[ 82]  + 273.15 "74 degC converted to K";
Modelica.Units.SI.Temperature  T_Not_in_pt75= datareader.y[ 83]  + 273.15 "75 degC converted to K";
Modelica.Units.SI.Temperature  T_Not_out_pt76= datareader.y[ 84]  + 273.15 "76 degC converted to K";
Modelica.Units.SI.Temperature  T_Not_MT_in_pt77= datareader.y[ 85]  + 273.15 "77 degC converted to K";
Modelica.Units.SI.Temperature  T_Not_MT_out_pt78= datareader.y[ 86]  + 273.15 "78 degC converted to K";
Modelica.Units.SI.Temperature  T_WRG_in_pt79= datareader.y[ 87]  + 273.15 "79 degC converted to K";
Modelica.Units.SI.Temperature  T_WRG_out_pt80= datareader.y[ 88]  + 273.15 "80 degC converted to K";
Modelica.Units.SI.Temperature  T_WRG_MT_in_pt81= datareader.y[ 89]  + 273.15 "81 degC converted to K";
Modelica.Units.SI.Temperature  T_WRG_MT_out_pt82= datareader.y[ 90]  + 273.15 "82 degC converted to K";
Modelica.Units.SI.Temperature  T_HT_VL_pt83= datareader.y[ 91]  + 273.15 "83 degC converted to K";
Modelica.Units.SI.Temperature  T_HT_RL_pt84= datareader.y[ 92]  + 273.15 "84 degC converted to K";
Modelica.Units.SI.VolumeFlowRate  Vd_HT_clamp85= datareader.y[ 93]  * 1/3600/1000
                                                                                 "85 l/h to be converted to m3/s";
Real  HE_HT86= datareader.y[ 94]  "86 %";
Real  PU_Erd87= datareader.y[ 95]  "87 %";
Real  PU_MT88= datareader.y[ 96]  "88 %";
Real  PU_HT89= datareader.y[ 97]  "89 %";
Real  VEN_MT_Erd90= datareader.y[ 98]  "90 %";
Real  VEN_MT_WRG91= datareader.y[ 99]  "91 %";
Real  VEN_Not92= datareader.y[ 100]  "92 %";
Real  SWP_On93= datareader.y[ 101]  "93 %";
Real  PU_NT_Freigabe94= datareader.y[ 102]  "94 %";
Real  PU_HT_Freigabe95= datareader.y[ 103]  "95 %";
Real  PU_MT_Freigabe96= datareader.y[ 104]  "96 %";
Real  DI_Reserve97= datareader.y[ 105]  "97 %";
Modelica.Units.SI.Temperature  T_GEN_In_pt98= datareader.y[ 106]  + 273.15 "98 degC converted to K";
Modelica.Units.SI.Temperature  T_GEN_Out_pt99= datareader.y[ 107]  + 273.15 "99 degC converted to K";
Modelica.Units.SI.Temperature  T_ABS_In_pt100= datareader.y[ 108]  + 273.15 "100 degC converted to K";
Modelica.Units.SI.Temperature  T_ABS_Out_pt101= datareader.y[ 109]  + 273.15 "101 degC converted to K";
Modelica.Units.SI.Temperature  T_MT_ABS_Out_pt102= datareader.y[ 110]  + 273.15 "102 degC converted to K";
Modelica.Units.SI.Temperature  T_VER_Kreis_pt103= datareader.y[ 111]  + 273.15 "103 degC converted to K";
Real  STOP_Last_Ina104= datareader.y[ 112]  "104 %";
Real  Betriebsart_Wegra105= datareader.y[ 113]  "105 -";
Real  PU_MT_Wegra106= datareader.y[ 114]  "106 %";
Real  PU_HT_Wegra107= datareader.y[ 115]  "107 %";
Real  PU_NT_Wegra108= datareader.y[ 116]  "108 %";
Real  Backup_Wegra109= datareader.y[ 117]  "109 %";
Real  Stoerung_Wegra110= datareader.y[ 118]  "110 %";
Real  FAN_Kuehlturm_Wegra111= datareader.y[ 119]  "111 %";
Real  MI_Kaeltetraeger_Wegra112= datareader.y[ 120]  "112 %";
Real  MI_Heizwasserwasser_Wegra113= datareader.y[ 121]  "113 %";
Real  MI_Kuehlwasser_Wegra114= datareader.y[ 122]  "114 %";
Modelica.Units.SI.Temperature  T_HeizVL_Wegra115= datareader.y[ 123]  + 273.15 "115 degC converted to K";
Modelica.Units.SI.Temperature  T_KaltVL_Wegra116= datareader.y[ 124]  + 273.15 "116 degC converted to K";
Modelica.Units.SI.Temperature  T_KuehlVL_Wegra117= datareader.y[ 125]  + 273.15 "117 degC converted to K";
Modelica.Units.SI.Temperature  T_HeizRL_Wegra118= datareader.y[ 126]  + 273.15 "118 degC converted to K";
Modelica.Units.SI.Temperature  T_KaltRL_Wegra119= datareader.y[ 127]  + 273.15 "119 degC converted to K";
Modelica.Units.SI.Temperature  T_KuehlRL_Wegra120= datareader.y[ 128]  + 273.15 "120 degC converted to K";
Modelica.Units.SI.Temperature  T_Loesungsmittel_Wegra121= datareader.y[ 129]  + 273.15 "121 degC converted to K";
Modelica.Units.SI.Temperature  T_MT_Soll_Wegra122= datareader.y[ 130]  + 273.15 "122 degC converted to K";
Modelica.Units.SI.VolumeFlowRate  Vd_MT_mid123= datareader.y[ 131]  * 1/3600/1000
                                                                                 "123 l/h converted to m3/s";
Modelica.Units.SI.VolumeFlowRate  Vd_MT_clamp124= datareader.y[ 132]  * 1/3600/1000
                                                                                   "124 l/h converted to m3/s";
Modelica.Units.SI.Pressure  p_KondensatorGenerator_Wegra125= datareader.y[ 133]  * 100 "125 mbar to be converted to Pa";
Modelica.Units.SI.Pressure  p_VerdampferAbsorber_Wegra126= datareader.y[ 134]  * 100 "126 mbar to be converted to Pa";
Real  Start_Kuehlen_Wegra127= datareader.y[ 135]  "127 %";
Real  Start_KuehlenOhneAbsorber_Wegra128= datareader.y[ 136]  "128 %";
Real  LockSum_PU_KSek129= datareader.y[ 137]  "129 ";
Real  LockSum_HST_KSek130= datareader.y[ 138]  "130 ";
Real  LockSum_PU_WSek131= datareader.y[ 139]  "131 ";
Real  LockSum_HST_WSek132= datareader.y[ 140]  "132 ";
Real  LockSum_PU_MT133= datareader.y[ 141]  "133 ";
Real  LockSum_PU_Erd134= datareader.y[ 142]  "134 ";
Real  LockSum_PU_HT135= datareader.y[ 143]  "135 ";
Real  LockSum_HE_HT136= datareader.y[ 144]  "136 ";
Modelica.Units.SI.Temperature  T_WT_HT_IN_pt137= datareader.y[ 145]  + 273.15 "137 degC converted to K";
Modelica.Units.SI.Temperature  T_WT_HT_OUT_pt138= datareader.y[ 146]  + 273.15 "138 degC converted to K";
Modelica.Units.SI.Temperature  T_WT_MT_IN_pt139= datareader.y[ 147]  + 273.15 "139 degC converted to K";
Modelica.Units.SI.Temperature  T_WT_MT_OUT_pt140= datareader.y[ 148]  + 273.15 "140 degC converted to K";
Modelica.Units.SI.Temperature  T_HE_HT_aussen141= datareader.y[ 149]  + 273.15 "141 degC converted to K";
Modelica.Units.SI.Temperature  T_Misch_MT_pt142= datareader.y[ 150]  + 273.15 "142 degC converted to K";
Modelica.Units.SI.Temperature  T_Reserve_143143= datareader.y[ 151]  + 273.15 "143 degC converted to K";
Modelica.Units.SI.Temperature  T_Reserve_144144= datareader.y[ 152]  + 273.15 "144 degC converted to K";
Modelica.Units.SI.Energy  Q_Rekup_wmz145= datareader.y[ 153]  * 3.6e+6
                                                                      "145 kWh to Joules";
Modelica.Units.SI.Volume  V_Rekup_wmz146= datareader.y[ 154]  "146 m3";
Modelica.Units.SI.Temperature  T_Rekup_flow_wmz147= datareader.y[ 155]  + 273.15 "147 degC converted to K";
Modelica.Units.SI.Temperature  T_Rekup_return_wmz148= datareader.y[ 156]  + 273.15 "148 degC converted to K";
Modelica.Units.SI.Power  P_Rekup_wmz149= datareader.y[ 157]  "149 W";
Modelica.Units.SI.VolumeFlowRate  Vd_Rekup_wmz150= datareader.y[ 158]  * 1/3600/1000
                                                                                    "150 l/h converted to m3/s";

Real stationary= datareader.y[ 159]  "Indicate which stationary point it is";

  Modelica.Blocks.Sources.CombiTimeTable datareader(
    tableOnFile=true,
    tableName="data",
    fileName="... File cannot yet be shared. Details are under discussion",
    columns=2:160)
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

equation

   der(E_in_minus_out) = Q_balance;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=36000,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end sBSc_1m_Cfg0_20220804;
