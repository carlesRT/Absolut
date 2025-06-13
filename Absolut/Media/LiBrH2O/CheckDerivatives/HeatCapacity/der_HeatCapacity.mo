within Absolut.Media.LiBrH2O.CheckDerivatives.HeatCapacity;
model der_HeatCapacity "Check for implemented derivatives for heat capacity"

  package Medium_l = Modelica.Media.Water.WaterIF97_R1pT
    "Refrigerant liquid medium";
  package Medium_v = Modelica.Media.Water.WaterIF97_R2pT
    "Refrigerant vapour medium";
  package Medium_sol = Absolut.Media.LiBrH2O
    "Solution medium";

  // Start and end values,
  Modelica.Units.SI.Temperature T_start=273.15 + 55 "Temperature evaluation";
  Modelica.Units.SI.Temperature T_end=273.15 + 55.1 "Temperature evaluation";
  Modelica.Units.SI.MassFraction X_H2O_start=0.6 "Ratio of water";
  Modelica.Units.SI.MassFraction X_H2O_end=0.61 "Ratio of water";
  Modelica.Units.SI.Pressure p_start=8000 "Pressure in Pascals";
  Modelica.Units.SI.Pressure p_end=8500 "Pressure in Pascals";
  //
  Real pkPa_start = p_start/1000;
  Real pkPa_end = p_end/1000;

  // Differences
  Modelica.Units.SI.TemperatureDifference der_T=T_end - T_start;
  Real der_X_H2O = X_H2O_end - X_H2O_start;
  Real der_X_LiBr = - der_X_H2O;
  Real der_X_LiBr100 = der_X_LiBr*100;
  Real der_p = p_end - p_start;
  Modelica.Units.SI.SpecificHeatCapacity der_cp=cp_end - cp_start;

  // Specific heat capacity, cp
  Modelica.Units.SI.SpecificHeatCapacity cp_start=
      Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
      T_start,
      X_H2O_start,
      p_start);
  Modelica.Units.SI.SpecificHeatCapacity cp_end=
      Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp(
      T_end,
      X_H2O_end,
      p_end);
  // Approximate value for specific heat capacity at "end" conditions calculated with start value and its derivative.
  Modelica.Units.SI.SpecificHeatCapacity cp_derived=cp_start +
      Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp_der(
      T_start,
      X_H2O_start,
      p_start,
      der_T,
      der_X_H2O,
      der_p);
  // partial derivatives
  Real cp_derX = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp_derX(    T_start,X_H2O_start,p_start);
  Real cp_derT = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp_derT(    T_start,X_H2O_start,p_start);
  Real cp_derp = Absolut.Media.LiBrH2O.specificHeatCapacity_SSC_TXp_derp(    T_start,X_H2O_start,p_start);
  //  Aproximate value for specific heat capacity at "end" conditions calculated with start value and its partial derivatives
  Modelica.Units.SI.SpecificHeatCapacity cp_partialderived=cp_start + cp_derX*(
      der_X_LiBr*100) + cp_derT*der_T + cp_derp*der_p/1000;

  Modelica.Units.SI.SpecificHeatCapacity Diff=cp_end - cp_derived;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end der_HeatCapacity;
