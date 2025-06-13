within Absolut.Basic.Functions;
function Tfiring_TeTcdT
  "Return the minimum firing temperature for a particular design. Inputs are Temperature level at evaporator, condenser and heat transfer temperature difference."
  input Modelica.Units.SI.Temperature Te "Low temperature level";
  input Modelica.Units.SI.Temperature Tc "Intermediate temperature level";
  input Modelica.Units.SI.TemperatureDifference dT
    "Heat transfer temperature difference";
  output Modelica.Units.SI.Temperature T "Minimum firing temperature (high temperature level)";

protected
  Modelica.Units.SI.TemperatureDifference dTlift = Tc - Te "Temperature lift";

algorithm
  T := (Tc-Te) + 4*dT + Tc;
  annotation (Documentation(info="<html>
<p>Based on the zero order model [1], this function can be used to calculate the minimum firing temperature for a particular design. Inputs are Temperature level at evaporator, condenser, and heat transfer temperature difference.</p>
<h4>Approach:</h4>
<p>The most relevant simplifications that transform the Carnot model into this equation (function) is to assume that,</p>
<ul>
<li>the temperature difference between the internal temperatures (subscript i) at the condenser (subscript c) and generator (subscript h) , and the temperature difference between the condenser and the evaporator (subscript e) is the same.</li>
<li>the temperature differences between the machine (internal temperatures) and the surroundings (external temperatures) are equal at all three temperature levels, <span style=\"font-family: Courier New;\">&Delta;T</span>. </li>
</ul>
<p>Based on the second assumption, we got that, </p>
<p><span style=\"font-family: Courier New;\">&Delta;T=T<sub>e</sub>-T<sub>ei</span></sub></p>
<p><span style=\"font-family: Courier New;\">&Delta;T=T<sub>h</sub>-T<sub>hi</span></sub></p>
<p><span style=\"font-family: Courier New;\">&Delta;T=T<sub>ci</sub>-T<sub>c</span></sub></p>
<p>And from the first assumption we have, <span style=\"font-family: Courier New;\">T<sub>hi</sub>-T<sub>ci</sub> = T<sub>ci</sub>-T<sub>ei</span></sub>. we use the above relationship to substitute the internal temperatures...</p>
<p><span style=\"font-family: Courier New;\">Th - &Delta;T - T<sub>c</sub> - &Delta;T= T<sub>c</sub> + &Delta;T-T<sub>ei</sub> + &Delta;T</span></p>
<p>and solve for <span style=\"font-family: Courier New;\">Th</span></p>
<p><span style=\"font-family: Courier New;\">Th = 2T<sub>c</sub> - T<sub>ei</sub> + 4&Delta;T</span></p>
<h4>References:</h4>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"));
end Tfiring_TeTcdT;
