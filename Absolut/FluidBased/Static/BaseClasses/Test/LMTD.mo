within Absolut.FluidBased.Static.BaseClasses.Test;
model LMTD
  extends Modelica.Icons.Example;

  Real T_ = time;
  extends Absolut.FluidBased.Static.BaseClasses.LMTD;

  //Real error, error100;

equation
  //error = (dT_log - dT_Chen);
  //error100 = if dT_log > 0 then 100*(dT_log - dT_Chen)/dT_log else 0;

   dT1 = 0;
   dT2 = 0;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=200,
      Interval=0.001,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"));
end LMTD;
