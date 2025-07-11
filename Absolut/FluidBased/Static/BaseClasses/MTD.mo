within Absolut.FluidBased.Static.BaseClasses;
partial model MTD "Mean temperature difference"

  Modelica.Units.SI.TemperatureDifference dT1(start=2) "Temperature differences 1 for HX";
  Modelica.Units.SI.TemperatureDifference dT2(start=1) "Temperature differences 2 for HX";
  Modelica.Units.SI.TemperatureDifference dT_Chen "Chen approximation of LMTD";
  Modelica.Units.SI.TemperatureDifference dT_used "Used mean temperature difference";

  Modelica.Units.SI.TemperatureDifference dT_log "Logarithmic mean temperature difference (LMTD)";
  Boolean dTzero;

  parameter Boolean usedT_log = true "true to primarly use LMTD instead of Chen approximation";
  parameter Real tol = 0.1 "Tolerance for dT1=dT2 on LMTD calculation";
  parameter Boolean useNoEvent = true "true to use NoEvent operator";

equation

  if useNoEvent then
  dTzero = if not usedT_log then true elseif  dT1*dT1 < dT2*dT2 - tol or dT1*dT1 - tol > dT2*dT2 then false else true;
  dT_log = if not usedT_log then 0 elseif dT1 > 0 and dT2 > 0 and not dTzero then ((dT1) - (dT2))/log(dT1/dT2) else dT_Chen;
  dT_Chen = if dT1 >= 0 and dT2 >= 0 then ((1/2)*dT1^0.3275 + (1/2)*dT2^0.3275)^(1/0.3275) else Modelica.Constants.eps;
  dT_used = if usedT_log then dT_log else dT_Chen;
  else
  dTzero = false;
  dT_log = if not usedT_log then 0 elseif noEvent(dT1 > 0) and noEvent(dT2 > 0) then ((dT1) - (dT2))/log(dT1/dT2) else dT_Chen;
  dT_Chen = if noEvent(dT1 >= 0) and noEvent(dT2 >= 0) then ((1/2)*dT1^0.3275 + (1/2)*dT2^0.3275)^(1/0.3275) else Modelica.Constants.eps;
  dT_used = if usedT_log then dT_log else dT_Chen;
  end if;


  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=50,
      Interval=0.001,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"));
end MTD;
