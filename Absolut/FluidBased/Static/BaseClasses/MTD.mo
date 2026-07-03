within Absolut.FluidBased.Static.BaseClasses;
partial model MTD "Mean temperature difference"

  Modelica.Units.SI.TemperatureDifference dT1(start=2, nominal = 5) "Temperature differences 1 for HX";
  Modelica.Units.SI.TemperatureDifference dT2(start=1, nominal = 5) "Temperature differences 2 for HX";
  Modelica.Units.SI.TemperatureDifference dT_Chen(nominal = 5) "Chen approximation of LMTD";
  Modelica.Units.SI.TemperatureDifference dT_used(nominal = 5) "Used mean temperature difference";

  Modelica.Units.SI.TemperatureDifference dT_log(nominal = 5) "Logarithmic mean temperature difference (LMTD)";
  Boolean dTzero;

  parameter Boolean usedT_log = true "true to primarly use LMTD instead of Chen approximation";
  parameter Real tol = 0.1 "Tolerance for dT1=dT2 on LMTD calculation";
  parameter Modelica.Units.SI.TemperatureDifference dT_min = 1e-6 "Minimal temperature difference";

equation

  dTzero =
  noEvent(abs(dT1 - dT2) <= tol*max(1, max(abs(dT1), abs(dT2))));

  dT_log = if usedT_log then 
  smooth(1,
    if noEvent(dT1 > dT_min
                         and dT2 > dT_min
                         and not dTzero) then
      (dT1 - dT2)/log(dT1/dT2)
    else
      dT_Chen)
      else 0;
      
   dT_Chen =
    smooth(1,
      if noEvent(dT1 >= 0 and dT2 >= 0) then
        ((0.5*max(dT1, dT_min)^0.3275
        + 0.5*max(dT2, dT_min)^0.3275))^(1/0.3275)
      else
        dT_min);     

  dT_used = if usedT_log then dT_log else dT_Chen;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end MTD;
