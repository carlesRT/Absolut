within Absolut.FluidBased.Static.BaseClasses;
partial model ChenMTD "Mean temperature difference"

  Modelica.Units.SI.TemperatureDifference dT1(start=2) "Temperature differences 1 for HX";
  Modelica.Units.SI.TemperatureDifference dT2(start=1) "Temperature differences 2 for HX";
  Modelica.Units.SI.TemperatureDifference dT_Chen "Chen approximation of LMTD";
  Modelica.Units.SI.TemperatureDifference dT_used "Used mean temperature difference";

equation

  dT_Chen = if dT1 >= 0 and dT2 >= 0 then ((1/2)*dT1^0.3275 + (1/2)*dT2^0.3275)^(1/0.3275) else Modelica.Constants.eps;
  dT_used = dT_Chen;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChenMTD;
