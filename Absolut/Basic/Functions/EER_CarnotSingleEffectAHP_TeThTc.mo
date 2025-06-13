within Absolut.Basic.Functions;
function EER_CarnotSingleEffectAHP_TeThTc
  "Cooling COP (EER) of a Carnot-based single effect absorption heat pump"

  input Modelica.Units.SI.Temperature Te "Low temperature level";
  input Modelica.Units.SI.Temperature Th "High temperature level";
  input Modelica.Units.SI.Temperature Tc "Intermediate temperature level";
  output Real EER "Cooling COP";

algorithm
  EER := (Th-Tc)/Th * Te/(Tc-Te);

  annotation (Documentation(info="<html>
<p>This function calculates the cooling efficiency (EER) of an single effect absorption chiller based on a Carnot cycle.</p>
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
<p><br><h4>References:</h4></p>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"));
end EER_CarnotSingleEffectAHP_TeThTc;
