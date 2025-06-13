within Absolut.Basic.Examples;
model HeatingCOP_SingleEffectAHP
  "Heating COP. Functions are used analogously to example CoolingCOP_SingleEffectAHP"

  extends Modelica.Icons.Example;
  parameter Modelica.Units.SI.Temperature Tc=273.15 + 35;
  parameter Modelica.Units.SI.Temperature Te=273.15 + 5;
  Modelica.Units.SI.Temperature Th= 350 + 1*time;
  Modelica.Units.SI.Temperature Heat_input_temperature=Th;

  Real ZeroOrderModel = Absolut.Basic.Functions.COP_SingleEffectAHP_TcTh(Tc,Th);
  Real Carnot = Absolut.Basic.Functions.COP_CarnotSingleEffectAHP_TeThTc(Te,Th,Tc);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StopTime=100,
      Interval=1,
      Tolerance=1e-07),
    Documentation(info="<html>
<p>This model is used to replicate the figure 2.8 of [1]. </p>
<p>It calculates the efficiency based on a Carnot cycle and a zero-order model as a function of the high temperature. The temperature at the low and intermediate level are kept constant at 5&deg;C and 35 &deg;C respectively. </p>
<p>Once the simulation is done, the script &quot;generate figure&quot; can be used to generate a formated figure.</p>
<h4>References:</h4>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"),
    __Dymola_Commands(file="Resources/Basic/COPh vs T.mos" "Plot COPh vs T"));
end HeatingCOP_SingleEffectAHP;
