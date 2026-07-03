within Absolut.FluidBased.Static.BaseClasses;
partial model ChenMTD "Mean temperature difference"

  Modelica.Units.SI.TemperatureDifference dT1(start=2, nominal = 5) "Temperature differences 1 for HX";
  Modelica.Units.SI.TemperatureDifference dT2(start=1, nominal = 5) "Temperature differences 2 for HX";
  Modelica.Units.SI.TemperatureDifference dT_Chen(nominal = 5) "Chen approximation of LMTD";
  Modelica.Units.SI.TemperatureDifference dT_used(nominal = 5) "Used mean temperature difference";
  parameter Modelica.Units.SI.TemperatureDifference dT_min = 1e-6 "Minimal temperature difference";


equation

  dT_Chen = if dT1 >= 0 and dT2 >= 0 then ((1/2)*dT1^0.3275 + (1/2)*dT2^0.3275)^(1/0.3275) else dT_min;
  dT_used = dT_Chen;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChenMTD;
