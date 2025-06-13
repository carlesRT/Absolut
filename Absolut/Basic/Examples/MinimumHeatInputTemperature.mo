within Absolut.Basic.Examples;
model MinimumHeatInputTemperature
  "Functions are used to solve example 2.1 of the book \"Absorption Chillers and Heat Pums\""

  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature Tc=273.15 + 35 "Rejection temperature";
  parameter Modelica.Units.SI.Temperature Te=273.15 + 8 "Refrigeration temperature";
  Modelica.Units.SI.TemperatureDifference dT[3]={0,5,10} "Temperature difference";
  Modelica.Units.SI.Temperature T[3] "Minimum heat input temperature";

equation
  T[1] = Absolut.Basic.Functions.Tfiring_TeTcdT(
    Te,
    Tc,
    dT[1]);
  T[2] = Absolut.Basic.Functions.Tfiring_TeTcdT(
    Te,
    Tc,
    dT[2]);
  T[3] = Absolut.Basic.Functions.Tfiring_TeTcdT(
    Te,
    Tc,
    dT[3]);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      Interval=1,
      Tolerance=1e-07),
    Documentation(info="<html>
<p>Example 2.1: Determine minimum heat input temperature [1].</p>
<p>The assumptions are a rejection temperature of 35&deg;C and a refrigeration temperature of 8&deg;C.</p>
<p><br><b>References:</b></p>
<p>[1] Keith E. Herold, Reinhard Radermacher, Sanford A. Klein. Absorption chillers and heat pumps. ISBN 978-1-4987-1435-8.</p>
</html>"),
    __Dymola_Commands(file="Resources/Basic/MinimumTemperature.mos" "MinimumTemperature"));
end MinimumHeatInputTemperature;
