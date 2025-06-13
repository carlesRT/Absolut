within Absolut.FluidBased.Static.BaseClasses.Test;
model ChenMTD
  extends Modelica.Icons.Example;

  Real T_ = time;
  extends Absolut.FluidBased.Static.BaseClasses.ChenMTD;

  //Real error, error100;

equation
  //error = (dT_log - dT_Chen);
  //error100 = if dT_log > 0 then 100*(dT_log - dT_Chen)/dT_log else 0;

   dT1 = 10;
   dT2 = 10;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=200,
      Interval=0.001,
      Tolerance=1e-05,
      __Dymola_Algorithm="Dassl"));
end ChenMTD;
