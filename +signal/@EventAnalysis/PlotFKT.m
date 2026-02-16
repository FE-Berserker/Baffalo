function PlotFKT(obj)


FKT=obj.output.FKT;
fks=FKT.fks;
f=FKT.f;
k=FKT.k;

figure
imagesc(k,f,abs(fks));
axis xy
xlabel('Wavenumber k_x');
ylabel('Frequency [Hz]');
set(gca, 'YDir', 'reverse');
colormap jet
colorbar
end

