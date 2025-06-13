within Absolut.FluidBased.Static.BaseClasses;
partial model LMTD "Mean temperature difference"

  Modelica.Units.SI.TemperatureDifference dT1(start=2) "Temperature differences 1 for HX";
  Modelica.Units.SI.TemperatureDifference dT2(start=1) "Temperature differences 2 for HX";
  Modelica.Units.SI.TemperatureDifference dT_used "Used mean temperature difference";
  Modelica.Units.SI.TemperatureDifference dT_log "Logarithmic mean temperature difference (LMTD)";
  Boolean dTzero;
  parameter Real tol = 0.1 "Tolerance for dT1=dT2";


equation

  dTzero = if dT1*dT1 < dT2*dT2 - tol or dT1*dT1 - tol > dT2*dT2 then false else true;
  dT_log = if dT1 > 0 and dT2 > 0 and not dTzero then ((dT1) - (dT2))/log((dT1)/(dT2)) else (dT1+dT2)/2;
  dT_used = dT_log;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end LMTD;
