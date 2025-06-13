within Absolut.FluidBased.Dynamic.LabValidation.ThermalOil;
function der_specificHeatCapacityCp_ext "Return the specific heat capacity at constant pressure"
  extends Modelica.Icons.Function;
  input ThermodynamicState state "Thermodynamic state record";
  input ThermodynamicState der_state "Thermodynamic state record";
  output Real der_cp(unit = "J/(kg.K.s)") "Specific heat capacity at constant pressure";
protected
  parameter Real c = 0.00334662;
algorithm
  der_cp := 1000 * c;
  annotation (
    Inline = true,
    Documentation(info = "<html>
<p>
This function returns the specific heat capacity at constant pressure.
</p>
</html>",
        revisions="<html>

</html>"));
end der_specificHeatCapacityCp_ext;
