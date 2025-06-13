within Absolut.Basic.Examples;
model DDT10_AHT
  "Use of on DDT on AHT (Type II AHP) application (highest temperature at absorber)."

  extends Modelica.Icons.Example;
  Modelica.Units.SI.Temperature Te  "Evaporator temperature. Similar to generator temperature";
  parameter Modelica.Units.SI.Temperature Tc = 273.15 + 30 "Condenser (low temperature)";
  parameter Modelica.Units.SI.Temperature Ta = 273.15 + 80 "Absorber (high temperature)";
  Modelica.Units.SI.Temperature Tg = Te "Generator temperature. Similar to evaporator temperature";
  parameter Real B = 1.15 "Duehring parameter";

  Real DDT(unit="K") =  10 "Characteristic temperature difference";

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
<p>Example calculate the temperature at the evaporator and generator, given the temperatures at the condenser and absorber, assuming a characteristic temperature difference DDT = 10 K.</p>
</html>"),
    __Dymola_Commands(file="Resources/Basic/DDT.mos" "Plot results"));
end DDT10_AHT;
