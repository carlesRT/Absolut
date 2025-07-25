within Absolut.Media.LiBrH2O.CheckDerivatives.HeatCapacity;
model derX_HeatCapacity "Check for implemented derivatives for heat capacity"

  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";

  // Start and end values,
  Modelica.Units.SI.Temperature T_start=273.15 + 55 "Temperature evaluation";
  Modelica.Units.SI.MassFraction X_H2O_start=0.6 "Ratio of water";
  Modelica.Units.SI.MassFraction X_H2O_end=0.61 "Ratio of water";
  Modelica.Units.SI.Pressure p_start=8000 "Pressure in Pascals";
  //
  Real pkPa_start = p_start/1000;
  // Differences
  Real der_X_H2O = X_H2O_end - X_H2O_start;
  Real der_X_LiBr = - der_X_H2O;
  Real der_X_LiBr100 = der_X_LiBr*100;
  Modelica.Units.SI.SpecificHeatCapacity der_cp=cp_end - cp_start;
  // Specific heat capacity, cp
  Modelica.Units.SI.SpecificHeatCapacity cp_start=
      Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
      T_start,
      X_H2O_start,
      p_start);
  Modelica.Units.SI.SpecificHeatCapacity cp_end=
      Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
      T_start,
      X_H2O_end,
      p_start);
  // Approximate value for specific heat capacity at "end" conditions calculated with start value and its derivative.
  Modelica.Units.SI.SpecificHeatCapacity cp_derived=cp_start +
      Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp_der(
      T_start,
      X_H2O_start,
      p_start,
      0,
      der_X_H2O,
      0);
  // partial derivatives
  Real cp_derX = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp_derX(    T_start,X_H2O_start,p_start);
  //  Aproximate value for specific heat capacity at "end" conditions calculated with start value and its partial derivatives
  Modelica.Units.SI.SpecificHeatCapacity cp_partialderived=cp_start + cp_derX*(
      der_X_LiBr*100);

  Modelica.Units.SI.SpecificHeatCapacity Diff=cp_end - cp_derived;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end derX_HeatCapacity;
