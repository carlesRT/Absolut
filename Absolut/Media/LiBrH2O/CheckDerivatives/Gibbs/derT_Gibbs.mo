within Absolut.Media.LiBrH2O.CheckDerivatives.Gibbs;
model derT_Gibbs

  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";

  // Start and end values,
  Modelica.Units.SI.Temperature T_start=273.15 + 50 "Temperature evaluation";
  Modelica.Units.SI.Temperature T_end=273.15 + 51 "Temperature evaluation";
  Modelica.Units.SI.MassFraction X_H2O_start=0.56 "Ratio of water";
  Modelica.Units.SI.MassFraction X_H2O_end=X_H2O_start "Ratio of water";
  Modelica.Units.SI.Pressure p_start=5000 "Pressure in Pascals";
  Modelica.Units.SI.Pressure p_end=p_start "Pressure in Pascals";
  //
  Real pkPa_start = p_start/1000;
  Real pkPa_end = p_end/1000;

  // Differences
  Modelica.Units.SI.TemperatureDifference der_T=T_end - T_start;

  // GibbsEnergy: g
  Modelica.Units.SI.SpecificEnergy g_start=
      Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp(
      T_start,
      X_H2O_start,
      p_start);
  Modelica.Units.SI.SpecificEnergy g_end=
      Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp(
      T_end,
      X_H2O_end,
      p_end);
  Modelica.Units.SI.SpecificEnergy g_derived=g_start +
      Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_der(
      T_start,
      X_H2O_start,
      p_start,
      der_T,
      0,
      0);
  Modelica.Units.SI.SpecificEnergy g_partialderived=g_start +
      Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_derT(
      T_start,
      X_H2O_start,
      p_start)*der_T;

  Modelica.Units.SI.SpecificEnergy Diff=g_end - g_derived;
  Real Diff_pc = Diff/(g_end-g_start);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end derT_Gibbs;
