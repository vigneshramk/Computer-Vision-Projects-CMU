% Object class for 2D Translation warps  
%
% Written by Simon Lucey 2015
classdef Translation        
    % Define constant properties
    properties(Constant)
        P = 2; % Degrees of freedom in the warp
    end
    properties
    end
     methods
        %% ----------------------------------------------------------------
        % Constructor function for the Translation Warp
        function o = Translation(varargin)
            % This is empty at the moment
        end
        %% ----------------------------------------------------------------
        % Function to warp the image
        %
        % <input> img = image
        %           p = warp parameters
        %       dsize = [rows, cols] of warped image
        function wimg = imwarp(o, img, p, dsize)
            % Form the transform matrix 
            % Note it is the inverse since it transforming from the image to the template 
            M = inv(o.p2M(p)); 
            tform = maketform('affine',M'); % Set the transform
            % Apply the transformation (using bilinear interpolation)
            wimg = imtransform(img, tform,'bilinear','xdata',[0,dsize(2)-1],'ydata',[0,dsize(1)-1]);  
        end
        %% ----------------------------------------------------------------
        % Function to draw the warp on the image
        function varargout = draw(o, p, dsize, varargin)
            % Define the template coords
            tmplt_coords = [0, dsize(2)-1, dsize(2)-1, 0, 0;
                            0, 0, dsize(1)-1, dsize(1)-1, 0]; 
                        
            % Apply the inverse warp 
            img_coords = o.apply(tmplt_coords, p); 
            
            % Finally draw the result
            hold on; 
            h = plot(img_coords(1,:),img_coords(2,:),varargin{:}); 
            hold off    
            
            % If it is required return the handle
            if nargout > 0
                varargout{1} = h; 
            end
        end  
        %% ----------------------------------------------------------------
        % Function to re-draw the warp given the handle
        function redraw(o, p, dsize, h)
            % Define the template coords
            tmplt_coords = [0, dsize(2)-1, dsize(2)-1, 0, 0;
                            0, 0, dsize(1)-1, dsize(1)-1, 0]; 
                        
            % Apply the inverse warp 
            img_coords = o.apply(tmplt_coords, p);
            
            % Set the x- and y- coordinates
            set(h,'XData',img_coords(1,:)); 
            set(h,'YData',img_coords(2,:)); 
        end
        %% ----------------------------------------------------------------
        % Form the warp matrix M from p vector 
        %
        function M = p2M(o,p)
            M = [1,   0, p(1); 
                 0,   1, p(2);
                 0,   0,   1];            
        end        
        %% ----------------------------------------------------------------
        % Form the p vector from the warp matrix M 
        %
        function p = M2p(o,M)
            p(1) = M(1,3); 
            p(2) = M(2,3);
            p = p(:); 
        end
        %% ----------------------------------------------------------------
        % The derivative of the warp function for an Translation warp w.r.t p
        %
        % Usage:- [dWx,dWy] = o.dWx_dp(p)
        %
        % <input>   
        %           x = x-coordinates 
        %           p = input warp vector (not needed for the Translation warp)
        %
        % <output> dWx = gradient in x with respect to p
        %          dWy = gradient in y with respect to p
        %
        function [dWx,dWy] = dWx_dp(o, x, y, varargin)
            x = x(:); y = y(:); % Vectorize everything
            v1 = ones(size(x)); v0 = zeros(size(x));
            % Form the derivative of the warp function (as discussed in
            % class)
            dWx = [ v1, v0]; 
            dWy = [ v0, v1]; 
        end
        %% ----------------------------------------------------------------
        % Fit the warp function between the source and destination planar 
        % points.
        %
        function p = fit(o, src, dst)
            [dWx,dWy] = o.dWx_dp(src(1,:),src(2,:));
            J = [dWx;dWy]; % Jacobian matrix
            % Get the error between dst and src
            err_x = dst(1,:) - src(1,:); 
            err_y = dst(2,:) - src(2,:);
            % Now solve for p using "backslash"!!!!
            p = J\[err_x,err_y]'; 
        end        
        %% ----------------------------------------------------------------
        % Apply the warp function
        function wpts = apply(o, pts, p)
            M = o.p2M(p); % Get the warp matrix 
            wpts = M(1:2,:)*[pts;ones(1,size(pts,2))]; % Apply the warp function 
        end        
        %% ----------------------------------------------------------------
        % Apply the inverse warp function
        function wpts = inv_apply(o, pts, p)
            M = inv(o.p2M(p)); % Get the inverse warp matrix 
            wpts = M(1:2,:)*[pts;ones(1,size(pts,2))]; % Apply the warp function 
        end  
     end
end
