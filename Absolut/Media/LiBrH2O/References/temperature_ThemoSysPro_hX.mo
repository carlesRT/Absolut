within Absolut.Media.LiBrH2O.References;
function temperature_ThemoSysPro_hX
  "Temperature of the H2O/LiBr solution as a function of h and X_LiBr"
   //ThermoSysPro
  input SpecificEnthalpy h "Specific enthazlpy of the solution";
  input MassFraction X_H2O "Water mass fraction in the solution";
  output Temperature T "Temperature";
protected
  MassFraction X_LiBr = 1 - X_H2O "LiBr mass fraction in the solution";
  constant Real[6] A = {-1.311645958E+03, 1.084550019E+04, -2.942661413E+04, 3.968957688E+04, -2.659706323E+04, 7.073041837E+03};
  constant Real[6] B = {8.271482051E-03, -5.828427688E-02, 1.733914006E-01, -2.547248076E-01, 1.831371685E-01, -5.155160151E-02};
  constant Real[7] C = {-2.454384671E-08, 2.318831106E-07, -8.983047414E-07, 1.818359590E-06, -2.027614981E-06, 1.181863048E-06, -2.816450830E-07};
  Real[7] X = {(1-X_LiBr)^i for i in 0:6} "Aux. array";
  Real[3] h_aux = {h^i for i in 0:2} "Aux. array";
algorithm
  T := {A*X[1:6], B*X[1:6], C*X}*h_aux;
  annotation (derivative=Absolut.Media.LiBrH2O.References.temperature_ThermoSysPro_hX_der);
end temperature_ThemoSysPro_hX;
