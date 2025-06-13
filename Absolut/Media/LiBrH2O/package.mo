within Absolut.Media;
package LiBrH2O "H2O + LiBr"
  extends Modelica.Media.Interfaces.PartialMedium(
    reducedX=true,
    mediumName="LiBrH2O",
    substanceNames={"Water","LiBr"},
    singleState=false,
    final ThermoStates=Modelica.Media.Interfaces.Choices.IndependentVariables.pTX);

  constant MolarMass MM_LiBr = 0.08685 "Molar mass of LiBr";
  constant MolarMass MM_H2O = 0.018015268 "Molar mass of water";

  redeclare record extends ThermodynamicState "Thermodynamic state"
    AbsolutePressure p "Pressure";
    Temperature T "Temperature";
    MassFraction[nX] X(start=reference_X) "Mass fractions (= (component mass)/total mass  m_i/m)";
  end ThermodynamicState;

  redeclare replaceable model extends BaseProperties(
    p(each stateSelect =  if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    T(each stateSelect =  if preferredMediumStates then StateSelect.prefer else StateSelect.default),
    Xi(each stateSelect = if preferredMediumStates then StateSelect.prefer else StateSelect.default))

  equation
    R_s = 0;
    MM = 1 / (((1-X[1])/MM_LiBr) + (X[1]/MM_H2O));

    h = specificEnthalpy_SSC_TXp(T, X[1],p);
    d = density_SSC_TXp(T, X[1],p);

    u = h - p/d;

    state.p = p;
    state.T = T;
    state.X = X;

  end BaseProperties;

  redeclare function setState_pTX
    "Return thermodynamic state from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input Temperature T "Temperature";
    input MassFraction X[:] "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state:=if size(X, 1) == nX then
      ThermodynamicState(p=p, T=T, X=X) else
      ThermodynamicState(p=p, T=T, X=cat(1, X, {1 - sum(X)}));
  end setState_pTX;

  redeclare function setState_phX
    "Return thermodynamic state from p, T, and X or Xi"
    extends Modelica.Icons.Function;
    input AbsolutePressure p "Pressure";
    input SpecificEnthalpy h "Specific enthazlpy of the solution";
    input MassFraction X[:] "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
  state := if size(X, 1) == nX then ThermodynamicState(
      p=p,
      T=Absolut.Media.LiBrH2O.temperature_hXp(
        h,
        X[1],
        p),
      X=X) else ThermodynamicState(
      p=p,
      T=Absolut.Media.LiBrH2O.temperature_hXp(
        h,
        X[1],
        p),
      X=cat(
        1,
        X,
        {1 - sum(X)}));
  end setState_phX;

  redeclare function setState_dTX
    "Return thermodynamic state from d, T, and X or Xi"
    extends Modelica.Icons.Function;
    input Density d "Density";
    input Temperature T "Temperature";
    input MassFraction X[:] "Mass fractions";
    output ThermodynamicState state "Thermodynamic state record";
  algorithm
    state:=if size(X, 1) == nX then
      ThermodynamicState(p=pressure_dTX(d,T,X[1]), T=T, X=X) else
      ThermodynamicState(p=pressure_dTX(d,T,X[1]), T=T, X=cat(1, X, {1 - sum(X)}));
  end setState_dTX;

  redeclare function extends pressure
  "Specific enthalpy w.r.t. thermodynamic state | use setState_phX function for input"
  algorithm
    p := state.p;
  end pressure;

  redeclare function extends temperature
  "Specific enthalpy w.r.t. thermodynamic state | use setState_phX function for input"
  algorithm
    T := state.T;
  end temperature;

  redeclare function extends specificEnthalpy
  "Specific enthalpy w.r.t. thermodynamic state | use setState_phX function for input"
  algorithm
    h :=Absolut.Media.LiBrH2O.specificEnthalpy_SSC_TXp(
        state.T,
        state.X[1],
        state.p);
        annotation(Inline=true, smoothOrder = 10);
  end specificEnthalpy;

  redeclare function extends specificEntropy
    "Specific Entropy w.r.t. thermodynamic state | use setState_phX function for input"
  algorithm
    s :=Absolut.Media.LiBrH2O.specificEntropy_SSC_TXp(
        state.T,
        state.X[1],
        state.p);
        annotation(Inline=true, smoothOrder = 10);
  end specificEntropy;

  redeclare function extends density
  "Density"
  algorithm
    d := Absolut.Media.LiBrH2O.density_SSC_TXp(state.T, state.X[1], state.p);
    annotation(Inline=true, smoothOrder = 10);
  end density;

  redeclare function extends dynamicViscosity
    "Dynamic viscosity"
  algorithm
    eta :=dynamicViscosity_SSC_TX(state.T, state.X[1]);
      annotation (Inline=true, smoothOrder = 10);
  end dynamicViscosity;

  redeclare function extends specificHeatCapacityCp
    "Specific heat capacity at constant pressure | turns infinite in two-phase region! | use setState_phX function for input"

  algorithm
    cp :=specificHeatCapacity_SSC_TXp(state.T, state.X[1],state.p);
    annotation(Inline=true,smoothOrder = 10);
  end specificHeatCapacityCp;

    redeclare function extends specificInternalEnergy
          "Specific heat capacity at constant pressure | turns infinite in two-phase region! | use setState_phX function for input"

    algorithm
    u := specificEnthalpy(state) - pressure(state)/density(state);
      annotation(Inline=true,smoothOrder = 10);
    end specificInternalEnergy;

  redeclare function extends thermalConductivity
    "thermalConductivity w.r.t. thermodynamic state | use setState_phX function for input"
  algorithm
    lambda :=thermalConductivity_SSC_TX(state.T, state.X[1]);
  end thermalConductivity;

  redeclare function extends specificGibbsEnergy
    "specificGibbsEnergy w.r.t. thermodynamic state | use setState_phX function for input"
  algorithm
    g := specificGibbsEnergy_TXp( state.T, state.X[1], state.p);
    annotation(Inline=true,smoothOrder = 10, derivative=Absolut.Media.LiBrH2O.specificGibbsEnergy_TXp_der);
  end specificGibbsEnergy;

  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>Calculation of fluid properties for aqueous lithium-bromide (LiBr+H2O) based on [1] and [2]. The functions provided by this package shall be used inside of the restricted limits according to the referenced literature.</p>
<p><br><b>References </b></p>
<p>[1] Yuan, Z. and Herold, E. Thermodynamic Properties of Aqueous Lithium Bromide Using a Multiproperty Free Energy Correlation. HVAC&amp;R Research, 2005.</p>
<p>[2] LiBrSSC (aqueous lithium bromide) Property Routines.</p>
<p><br>The Medium includes a package named References. Within this package functions from other sources are also implemented to cross-check the main implementation these are...</p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">[3] Chua, H. T., H. K. Toh, A. Malek, K. C. Ng, and K. Srinivasan. 2000. &ldquo;Improved Thermodynamic Property Fields of LiBr-H2O Solution.&rdquo; <i>International Journal of Refrigeration</i> 23 (6): 412&ndash;29. doi:10.1016/S0140-7007(99)00076-6.</span> </p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">[4] Consortium, Sorption Systems. n.d. &ldquo;LiBrSSC (Aqueous Lithium Bromide) Property Routines.&rdquo; Maryland. U.S.A.: University of Maryland. http://fchart.com/ees/libr_help/ssclibr.pdf.</span></p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">[5] EDF. n.d. &ldquo;ThermoSysPro.&rdquo; Paris, France. https://build.openmodelica.org/Documentation/ThermoSysPro.html.</span> </p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">[6] Kaita, Y. 2001. &ldquo;Thermodynamic Properties of Lithium Bromide - Water Solutions at High Temperatures.&rdquo; <i>International Journal of Refrigeration</i> 24 (5): 374&ndash;90. doi:10.1016/S0140-7007(00)00039-6.</span> </p>
<p style=\"margin-left: 30px;\"><span style=\"font-family: MS Shell Dlg 2;\">[7] McNeely, Lowell A. 1979. &ldquo;Thermodynamic Properties of Aqueous Solutions of Lithium Bromide.&rdquo; In <i>1979 Winter Conference</i>, 22. Philadelphia, PA: ASHRAE Transactions. http://www.techstreet.com/ashrae/standards/ph-79-03-3-thermodynamic-properties-of-aqueous-solutions-of-lithium-bromide?product_id=1853310.</span> </p>
</html>", revisions="<html>
</html>"));
end LiBrH2O;
