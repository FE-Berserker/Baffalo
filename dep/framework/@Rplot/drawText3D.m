function drawText3D(obj, x, y,z, str)
%DRAWTEXT Draw text. Wrapper to gkText.
    
    validateattributes(x,   {'numeric'}, {'real', 'scalar'});    
    validateattributes(y,   {'numeric'}, {'real', 'scalar'});
    validateattributes(z,   {'numeric'}, {'real', 'scalar'});
    validateattributes(str, {'char'},    {'nonempty','scalartext'});      
    
    ht=text(x,y,z,str,...
        'FontName',obj.text_options.font,...
        'FontSize',obj.text_options.base_size,...
        'FontWeight','normal');
    set(ht,'HorizontalAlignment',obj.annotation_options.HorizontalAlignment);
    set(ht,'VerticalAlignment',obj.annotation_options.VerticalAlignment);
    set(ht,'Rotation',obj.annotation_options.Rotation);

end
    