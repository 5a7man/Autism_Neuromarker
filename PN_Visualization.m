function PN_Visualization(rmse,threshold)
% loading essential data
sensors = ["Fp1", "Fp2", "F7", "F3", "Fz", "F4","F8", "T3", "C3", "Cz",...
    "C4", "T4", "T5", "P3", "Pz", "P4", "T6", "O1", "O2"];
mont = readmatrix("Montage.xlsx");
X = mont(:,2); Y = mont(:,3);

% plotting nodes
axis off;
box off;
hold on;
scatter(X,Y,10,"filled","MarkerEdgeColor",[1 0 0],"LineWidth",1.5,'MarkerFaceColor',[1,0,0]);
viscircles([0.002,-0.015],0.12,'Color','k');
textscatter(X,Y,sensors,"TextDensityPercentage",100);

% plotting links
k = 1;
for sensor_i = 1:19
    for sensor_j = sensor_i+1:19
        hold on;
        if rmse(k)>threshold
            plot([X(sensor_i),X(sensor_j)],[Y(sensor_i),Y(sensor_j)],"-r","LineWidth",1);
        else
            plot([X(sensor_i),X(sensor_j)],[Y(sensor_i),Y(sensor_j)],"-k","LineWidth",1);
        end
        k = k+1;
    end
end

end