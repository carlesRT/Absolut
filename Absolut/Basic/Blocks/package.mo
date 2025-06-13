within Absolut.Basic;
package Blocks

annotation (Icon(graphics={  Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-82,-72},{72,72}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="f",
          textStyle={TextStyle.Italic}),
      Rectangle(extent={{-84,78},{80,-76}}, lineColor={28,108,200}),
      Polygon(
        points={{-84,22},{-84,62},{-64,42},{-84,22}},
        lineColor={0,0,0},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid),
      Polygon(points={{80,-20},{80,20},{100,0},{80,-20}}, lineColor={0,0,0}),
      Polygon(
        points={{-84,-18},{-84,22},{-64,2},{-84,-18}},
        lineColor={0,0,0},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid),
      Polygon(
        points={{-84,-58},{-84,-18},{-64,-38},{-84,-58}},
        lineColor={0,0,0},
        fillColor={28,108,200},
        fillPattern=FillPattern.Solid)}), Documentation(info="<html>
<p>The functions included included within the package <a href=\"modelica://Absolut.Basic.Functions\">Absolut.ZeroOrder.Functions</a> are here modelled in a block-wise manner, to facilitate graphical modeling via the GUI.</p>
</html>"));
end Blocks;
