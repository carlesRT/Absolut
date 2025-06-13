within Absolut.Basic.Examples;
model DDT10_AHP

  extends Modelica.Icons.Example;
  Modelica.Units.SI.Temperature Te = 40 + 273.15 "Evaporator temperature. (low temperature)";
  parameter Modelica.Units.SI.Temperature Tc = 273.15 + 80 "Condenser (mid temperature)";
  parameter Modelica.Units.SI.Temperature Ta = 273.15 + 80 "Absorber (mid temperature)";
  Modelica.Units.SI.Temperature Tg "Generator temperature. (high temperature)";
  parameter Real B = 1.15 "Duehring parameter";

  Real DDT = 10 "Characteristic temperature difference";

equation
  DDT = Absolut.Basic.Functions.DDT(
    Te,
    Tc,
    Ta,
    Tg,
    B);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      Interval=1,
      Tolerance=1e-07),
    Documentation(info="<html>
<p>Example calculate the temperature at the generator, given the temperatures at the condenser, absorber and evaporator, assuming a characteristic temperature difference DDT = 10 K.</p>
</html>"),
    __Dymola_Commands(file="Resources/Basic/DDT.mos" "Plot results"));
end DDT10_AHP;
