within Absolut.Basic.Functions;
function EER_TripleEffectAHP_TeTh
  "Cooling efficiency EER of a zero-order model of a triple effect absorption heat pump"

  input Modelica.Units.SI.Temperature Te "Low temperature level";
  input Modelica.Units.SI.Temperature Th "High temperature level";
  output Real EER "Cooling COP";

algorithm
  EER := 3*Te/Th;

  annotation (Documentation(info="<html>
<p>This function calculates the cooling efficiency (EER) of a idealized triple effect absorption heat pump modelled as a so-called zero order model [1].</p>
<h4>References:</h4>
<p>[1] Herold, K.E., Radermacher, R., Klein, S.A. ABSORPTION CHILLERS AND HEAT PUMPS. ISBN-13: 978-1-4987-1435-8 </p>
</html>"));
end EER_TripleEffectAHP_TeTh;
