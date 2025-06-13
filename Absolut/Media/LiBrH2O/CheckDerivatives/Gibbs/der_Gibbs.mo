within Absolut.Media.LiBrH2O.CheckDerivatives.Gibbs;
model der_Gibbs

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
  Modelica.Units.SI.MassFraction X_H2O_end=0.561 "Ratio of water";
  Modelica.Units.SI.Pressure p_start=5000 "Pressure in Pascals";
  Modelica.Units.SI.Pressure p_end=5500 "Pressure in Pascals";
  //
  Real pkPa_start = p_start/1000;
  Real pkPa_end = p_end/1000;

  // Differences
  Modelica.Units.SI.TemperatureDifference der_T=T_end - T_start;
  Real der_X_H2O = X_H2O_end - X_H2O_start;
  Real der_X_LiBr = - der_X_H2O;
  Real der_p = p_end - p_start;

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
      der_X_H2O,
      der_p);
  Modelica.Units.SI.SpecificEnergy g_partialderived=g_start +
      Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_derX(
      T_start,
      X_H2O_start,
      p_start)*(der_X_LiBr*100) +
      Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_derT(
      T_start,
      X_H2O_start,
      p_start)*der_T + Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_derp(
      T_start,
      X_H2O_start,
      p_start)*der_p/1000;

  Modelica.Units.SI.SpecificEnergy Diff=g_end - g_derived;
  Real Diff_pc = Diff/(g_end-g_start);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end der_Gibbs;
