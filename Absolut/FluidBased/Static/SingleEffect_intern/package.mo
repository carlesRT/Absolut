within Absolut.FluidBased.Static;
package SingleEffect_intern "Vessels without interface to external fluids."
  extends Modelica.Icons.VariantsPackage;

annotation (Documentation(info="<html>
<p>The models included in this package focus on the internal cycle. I.e. there is no interface to external fluids and for that reason this kind of models cannot be used directly to size a machine (no UA values). </p>
<p>The main application of these models is the calculation of any (possible) operating condition. To define the operating conditions there are different possibilites. It is possible to define X_LiBr concentrations at the generator and/or absober, mass flow rate of the solution pump, opening signal of the two valves, and pressure at the high and low pressure vessels. It is possible to set up to three of these variables. The problem to be solved and relevant initial conditions might change from case to another so that some extra effort to set up the model, i.e. to define good start values, might be needed. </p>
<p><br>The results can be used to e.g. obtain a first estimation of the efficiency of the defined cycle. But also to obtain a better overview of the operation of the system. These information might be helpful to set start values for more complex models. </p>
</html>"));
end SingleEffect_intern;
