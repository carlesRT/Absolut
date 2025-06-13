within Absolut.Media.LiBrH2O.CheckDerivatives.ChemicalPotential;
model ChemicalPotential_w

  // Start and end values,
  Modelica.Units.SI.Temperature T_start=273.15 + 80 "Temperature evaluation";
  Modelica.Units.SI.Temperature T_end=273.15 + 80 "Temperature evaluation";
  Modelica.Units.SI.MassFraction X_H2O_start=0.4 "Ratio of water";
  Modelica.Units.SI.MassFraction X_H2O_end=0.4001 "Ratio of water";
  Modelica.Units.SI.Pressure p_start=6300 "Pressure in Pascals";
  Modelica.Units.SI.Pressure p_end=6300 "Pressure in Pascals";
  //
  Real pkPa_start = p_start/1000;
  Real pkPa_end = p_end/1000;

  // Differences
  Modelica.Units.SI.TemperatureDifference der_T=T_end - T_start;
  Real der_X_H2O = X_H2O_end - X_H2O_start;
  Real der_X_LiBr = - der_X_H2O;
  Real der_p = p_end - p_start;

  Modelica.Units.SI.SpecificEnergy m_w_start=
      Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
      T_start,
      X_H2O_start,
      p_start);
  Modelica.Units.SI.SpecificEnergy m_w_end=
      Absolut.Media.LiBrH2O.chemicalPotential_w_TXp(
      T_end,
      X_H2O_end,
      p_end);


  Real derivative = Absolut.Media.LiBrH2O.chemicalPotential_w_TXp_der(
      T_start,
      X_H2O_start,
      p_start,
      der_T,
      der_X_H2O,
      der_p);

  Modelica.Units.SI.SpecificEnergy m_w_derived=m_w_start +
      Absolut.Media.LiBrH2O.chemicalPotential_w_TXp_der(
      T_start,
      X_H2O_start,
      p_start,
      der_T,
      der_X_H2O,
      der_p);

  Real derivative_ref = (m_w_end - m_w_start);
  Modelica.Units.SI.SpecificEnergy Diff = m_w_end - m_w_derived;
  Real Diff_pc = Diff/(m_w_end - m_w_start);

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ChemicalPotential_w;
