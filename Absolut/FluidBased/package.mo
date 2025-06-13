within Absolut;
package FluidBased

annotation (Icon(graphics={
        Rectangle(
          lineColor={200,200,200},
          fillColor={248,248,248},
          fillPattern=FillPattern.HorizontalCylinder,
          extent={{-100,-100},{100,100}},
          radius=25.0),
        Polygon(points={{-70,28},{68,-42},{68,28},{2,-8},{-70,-40},{-70,28}},
            lineColor={0,0,0}),
        Line(points={{2,44},{2,-8}},  color={0,0,0}),
        Rectangle(
          extent={{-18,52},{22,44}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end FluidBased;
