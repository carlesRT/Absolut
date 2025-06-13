within Absolut.Basic.Functions;
function COP_SingleEffectAHP_TcTh
  "Heating efficiency COP of a zero-order model of single effect absorption heat pump"

  input Modelica.Units.SI.Temperature Tc "Intermediate temperature level";
  input Modelica.Units.SI.Temperature Th "High temperature level";
  output Real COP "Heating COP";

algorithm
  COP := 2*Tc/Th;

  annotation (Documentation(info="<html>
<p>This function calculates the heating efficiency (COP) of a idealized single effect absorption heat pump modelled as a so-called zero order model [1].</p>
<p>The basic assumptions used for the Carnot cycle holds. The zero order model [1] considers important irreversibilities such as the ones associated with the heat transfer with the external heat source (or sink) at the three temperature levels (not relevant for this function). The irreversibilities internal to the cycle are not considered.</p>
<h4>Approach:</h4>
<p>The most relevant simplifications that transform the Carnot model into this equation (function) is to assume that,</p>
<ul>
<li>the temperature difference between the internal temperatures (subscript i) the condenser and generator, and the temperature difference between the condenser and the evaporator is the same. (<span style=\"font-family: Courier New;\">T<sub>hi</sub>-T<sub>ci</sub> = T<sub>ci</sub>-T<sub>ei</span></sub>). </li>
</ul>
<p>The Carnot COP = (T<sub>hi</sub>-T<sub>ei</sub>)/T<sub>hi</sub> * T<sub>ci</sub>/(T<sub>ci</sub>-T<sub>ei</sub>) can be simplified to EER = 2(T<sub>ci</sub>)/T<sub>hi</sub>. </p>
<p><br>This approach is consider to produce good results on performance trends, but only rough approximations for absolute performance predictions.</p>
<h4>References:</h4>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"));
end COP_SingleEffectAHP_TcTh;
