within Absolut.Basic.Functions;
function COP_CarnotSingleEffectAHP_TeThTc
  "Heating COP (COP) of a Carnot-based single effect absorption heat pump"

  input Modelica.Units.SI.Temperature Te "Low temperature level";
  input Modelica.Units.SI.Temperature Th "High temperature level";
  input Modelica.Units.SI.Temperature Tc "Intermediate temperature level";
  output Real COP "Heating COP";

algorithm
  COP := (Th-Te)/Th * Tc/(Tc-Te);

  annotation (Documentation(info="<html>
<p>This function calculates the heating efficiency (COP) of an single effect absorption heat pump based on a Carnot cycle.</p>
<h4>Approach:</h4>
<p>The Carnot cycle is an idealized energy conversion cycle that has the highest possible performance. It is assumed as thermodynamically reversible process, i.e. a process without losses. Main assumptions are, </p>
<ul>
<li>isothermal heat transfer</li>
<li>isentropic power input and generation </li>
</ul>
<p>Additional assumptions used are, </p>
<ul>
<li>Condenser and the absorber operate at the same temperature</li>
</ul>
<h4>References:</h4>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"));
end COP_CarnotSingleEffectAHP_TeThTc;
