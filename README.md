# FloatingImageViewStack

FloatingImageViewStack is a simple custom control to let you layer floating images on top of eachother. Tap into any image in the stack to select the image and bring it into focus. Make sure to take a look at the example project included.

[![Simulator Screen Shot Feb 11, 2017, 7.56.07 PM.png](https://s23.postimg.org/9e01vpbnv/Simulator_Screen_Shot_Feb_11_2017_7_56_07_PM.png)](https://postimg.org/image/4fcjh67uv/)

---------------------

# How to Use and Setup 

FloatingImageViewStack is `IBDesignable` and many of the properties can be easily changed in the attributes inspect inside of interface builder. Listed below are all of the properties with default values that can be changed via Interface Builder.

```
@IBInspectable var verticalSpacing : CGFloat = 35
@IBInspectable var borderColor : UIColor = UIColor.clear
@IBInspectable var topBorderColor : UIColor = UIColor.black
@IBInspectable var topColor : UIColor = UIColor.clear
@IBInspectable var topOpacity : Float = 1.0
@IBInspectable var angle : CGFloat = -45
@IBInspectable var color : UIColor  = UIColor.clear
@IBInspectable var selectedBorderWidth : CGFloat = 3.0
@IBInspectable var animationDuration : CGFloat = 0.7
```

**Drag a view onto your view controller and subclass it as `FloatingImageViewStack` in interface builder.**

  [![Screen Shot 2017-02-11 at 8.06.48 PM.png](https://s27.postimg.org/hxakgdg9v/Screen_Shot_2017_02_11_at_8_06_48_PM.png)](https://postimg.org/image/yl22ivb1b/)

**Configure any properties via the attribute inspector.**

  [![Screen Shot 2017-02-11 at 8.07.01 PM.png](https://s24.postimg.org/6euu9ba2d/Screen_Shot_2017_02_11_at_8_07_01_PM.png)](https://postimg.org/image/di2poxfht/)
  
**Assign the `FloatingImageViewContainerDelegate` to receive user interactions.**

```
  class ViewController: UIViewController {    
      @IBOutlet weak var floatingImageStack: FloatingImageViewStack!

      override func viewDidLoad() {
          super.viewDidLoad()
          floatingImageStack.delegate = self
      }
   }

  extension ViewController : FloatingImageViewContainerDelegate {
      func didSelectFloatingTop() {

      }

      func didSelectFloatingImage(selectedView: FloatingImageView) {

      }
  }
```

**Finally, then simply add an image onto the stack.**

```  

floatingImageStack.addImageToStack(imageToAdd: UIImage(named: "sample_image")!) 

```

**Remove images from the stack by index.**

``` 

floatingImageStack.removeFloatingView(at: 0)

```

**Remove images from the stack directly.** 

```

  func didSelectFloatingImage(selectedView: FloatingImageView) {
        floatingImageStack.removeSelectedFloatingView(viewToRemove: selectedView)
    }

```

------------------------------

# Live Demonstration

![example_demo](https://cloud.githubusercontent.com/assets/24960143/22858735/f051f308-f093-11e6-914f-1859bd1f4c7f.gif)
