within Absolut.Basic.Functions;
function EER_SingleEffectAHP_TeTh
  "Cooling efficiency EER of a zero-order model of single effect absorption heat pump"

  input Modelica.Units.SI.Temperature Te "Low temperature level";
  input Modelica.Units.SI.Temperature Th "High temperature level";
  output Real EER "Cooling COP";

algorithm
  EER := Te/Th;

  annotation (Documentation(info="<html>
<p>This function calculates the cooling efficiency (EER) of a idealized single effect absorption chiller modelled as a so-called zero order model [1].</p>
<p>The basic assumptions used for the Carnot cycle holds. The zero order model [1] considers important irreversibilities such as the ones associated with the heat transfer with the external heat source (or sink) at the three temperature levels (not relevant for this function). The irreversibilities internal to the cycle are not considered.</p>
<h4>Approach:</h4>
<p>The most relevant simplifications that transform the Carnot model into this equation (function) is to assume that,</p>
<ul>
<li>the temperature difference between the internal temperatures (subscript i) at the condenser (subscript c) and generator (subscript h), and the temperature difference between the condenser and the evaporator (subscript e) is the same. (<span style=\"font-family: Courier New;\">T<sub>hi</sub>-T<sub>ci</sub> = T<sub>ci</sub>-T<sub>ei</span></sub>). </li>
</ul>
<p><br>The Carnot EER = <span style=\"font-family: Courier New;\">(T<sub>hi</sub>-T<sub>ci</sub>)/T<sub>hi</sub>&nbsp;*&nbsp;T<sub>ei</sub>/(T<sub>ci</sub>-T<sub>ei</sub>)</span> can be simplified to EER = (T<sub>ei</sub>)/T<sub>hi</sub>. </p>
<p><br>This approach is consider to produce good results on performance trends, but only rough approximations for absolute performance predictions.</p>
<h4>References:</h4>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"));
end EER_SingleEffectAHP_TeTh;
