within Absolut.Basic.Functions;
function DDT "DDT for Absorption heat transformer, AHP or chiller"

  input  Modelica.Units.SI.Temperature Te "Evaporator temperature. Similar to generator temperature for AHT. Lowest temperature in AHP/Chiller application";
  input  Modelica.Units.SI.Temperature Tc "Condenser temperature (low temperature in AHT application)";
  input  Modelica.Units.SI.Temperature Ta "Absorber temperature (high temperature in AHT application)";
  input  Modelica.Units.SI.Temperature Tg "Generator temperature. Similar to evaporator temperature. Highest temperature in AHP/Chiller application";

  input Real B = 1.15 "Duehring parameter. For LiBr-water systems, B tipically has a value between 1.1 and 1.2";

  output Real DDT "Characteristic temperature difference";

algorithm

  DDT := B*(Te - Tc) - (Ta - Tg);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Function to obtain the characteristic equation. Relevant references related to the characteristic equation method are listed below.</p>
<h4>References:</h4>
<p>[1] Ziegler, F., 1997. Sorptionsw&auml;rmepumpe, Forschungsberichte des Deutschen Klima- und K&auml;ltetechnischen Vereins e.V.</p>
<p>[2] Albers, J., Kuehn, A., Petersen, S., Ziegler, F., 2008. Control of absorption chillers by insight: the characteristic equation, in: Czasopismo Techniczne 2008 Int. Conf. Process Engineering Plant Design. Politechnika Krakowska,, Krakau, pp. 3&ndash;12.</p>
<p>[3] Cudok, F., Ziegler, F. 2015. Absorption heat converter and the characteristic equation method. in: International Congress of Refrigeration, Yokohama, Japan.</p>
</html>"));
end DDT;
