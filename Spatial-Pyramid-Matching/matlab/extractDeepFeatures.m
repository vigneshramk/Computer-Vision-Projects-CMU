function features = extractDeepFeatures(net,I)

I=imresize(I,[224,224]);

x=I;

for i=1:41
    
        if(strcmp(char(net.Layers(i).Name),'fc7'))
         fprintf('Fc7 Layer %d\n',i);
         W=net.Layers(i).Weights;
         b=net.Layers(i).Bias;
         y = fully_connected2(x,W,b);   
         features=y';
        break;
        end
    
        if(strcmp(char(net.Layers(i).Name),'input'))
            fprintf('Input Layer %d\n',i);
            m=activations(net,zeros(224,224,3),'input','OutputAs','channels');
            y = mean_remove(x,m);
        end
        if(strncmpi(char(net.Layers(i).Name),'conv',4))
            fprintf('Conv Layer %d\n',i);
            h=net.Layers(i).Weights;
            b=net.Layers(i).Bias;
            stride_val=net.Layers(i).Stride;
            y1 = multichannel_conv2(x,h,b);
            y=stride(y1,stride_val);
        end
        if(strncmpi(char(net.Layers(i).Name),'relu',4))
            fprintf('ReLU Layer %d\n',i);
            y=relu(x);
        end
        if(strncmpi(char(net.Layers(i).Name),'pool',4))
            fprintf('Max-Pooling Layer %d\n',i);
            sz=net.Layers(i).PoolSize;
            stride_val=net.Layers(i).Stride;
            y1 = max_pool(x,sz);
            y=stride2(y1,stride_val);
        end
        if(strcmp(char(net.Layers(i).Name),'fc6'))
            fprintf('Fully-connected %d\n',i);
            W=net.Layers(i).Weights;
            b=net.Layers(i).Bias;
            y = fully_connected2(x,W,b);
        end
        
        x=y;
        features=y;
    end
end