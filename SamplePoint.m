classdef SamplePoint
    properties
        D1 {mustBeNumeric}
        D2 {mustBeNumeric}
        T1 {mustBeNumeric}
        T2 {mustBeNumeric}
    end
    methods
        function obj = SamplePoint(D1_in, D2_in, T1_in, T2_in)
            if nargin == 4
                obj.D1 = D1_in;
                obj.D2 = D2_in;
                obj.T1 = T1_in;
                obj.T2 = T2_in;
            end
        end
        
        %deepest point on cylinder
        function H1 = getH1()
            H1 = obj.T1 + obj.T2;
        end
        
        %deepest point on cone
        function H2 = getH2()
            H2 = obj.T2;
        end
        
        function r1 = getR1()
            r1 = obj.D1 / 2;
        end
        
        function r2 = getR2()
            r2 = obj.D2 / 2;
        end
    end
end