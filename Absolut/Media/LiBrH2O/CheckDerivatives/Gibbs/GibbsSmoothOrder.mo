within Absolut.Media.LiBrH2O.CheckDerivatives.Gibbs;
model GibbsSmoothOrder



  // Start and end values,
  Modelica.Units.SI.Temperature T_start=273.15 + 50 "Temperature evaluation";
  Modelica.Units.SI.Temperature T_end=273.15 + 55 "Temperature evaluation";
  Modelica.Units.SI.MassFraction X_H2O_start=0.56 "Ratio of water";
  Modelica.Units.SI.MassFraction X_H2O_end=0.56 "Ratio of water";
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


 Real GibbsSO =  Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_so(T_start + der_T*time,X_H2O_start+ der_X_H2O*time,p_start+ der_p*time);
 Real Gibbs =  Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp(T_start,X_H2O_start,p_start);


 Real derGibbsSO = der(GibbsSO);
 Real derderGibbsSO = der(derGibbsSO);
 Real derderderGibbsSO = der(derderGibbsSO);
 Real derGibbs = Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_der(T_start,X_H2O_start,p_start,der_T,der_X_H2O,der_p);


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=1,
      Interval=3600,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"),
    __Dymola_experimentSetupOutput,
    __Dymola_experimentFlags(
      Advanced(GenerateVariableDependencies=true, OutputModelicaCode=true),
      Evaluate=false,
      OutputCPUtime=true,
      OutputFlatModelica=true));
end GibbsSmoothOrder;
