<img src="https://user-images.githubusercontent.com/23136843/45270634-ed49a500-b475-11e8-815b-612a54aacd8c.png" width="550" title="Mozaic">

**Mozaic** is a library for building custom CollectionViews. It provides a simple interface for assembling a mosaic layout based in encapsulated columns and three cell types.

[![CI Status](https://img.shields.io/travis/luccafgf/Mozaic.svg?style=flat)](https://travis-ci.org/luccafgf/Mozaic)
[![Version](https://img.shields.io/cocoapods/v/Mozaic.svg?style=flat)](https://cocoapods.org/pods/Mozaic)
[![License](https://img.shields.io/cocoapods/l/Mozaic.svg?style=flat)](https://cocoapods.org/pods/Mozaic)
[![Platform](https://img.shields.io/cocoapods/p/Mozaic.svg?style=flat)](https://cocoapods.org/pods/Mozaic)

## Installation

Mozaic is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'Mozaic'
```

## Implementation and Usage

Import Mozaic to the Controller where it will be used.

```swift
import Mozaic
```

Now, create a constant with a Mozaic layout,  attribute it's to your collectionView layout and assign its delegate to the actual class.


```swift
override func viewDidLoad() {
super.viewDidLoad()
...
let mozaicLayout = Mozaic()
self.yourCollectionView.collectionViewLayout = mozaicLayout
mozaicLayout.delegate = self
...
}
```

At this point, you will see that Xcode will show an error saying that `mozaicLayout.delegate = self` cannot be assigned. It's because you have not yet extended your class with `MozaicDelegate`.

To fix this, do:

```swift
class YourViewController: MozaicDelegate {

...

}
```

Now, you will see that an error will appear, saying that your class doesn't conform with MozaicDelegate, and Xcode will ask you if do you want to add protocol stubs. After clicking the add button, the method `setStyleOfEachColumn` will appear.

This method returns an array with arrays of CellType, so if you pass an array like this:

```swift

func setStyleOfEachColumn() -> [[MozaicCellType]] {
return [[.Medium, .Small, .Medium], [.Large, .Small, .Small]]
}

```

You'll has a collection like in this image below

![sizes](https://user-images.githubusercontent.com/23136843/45269525-faf72e80-b465-11e8-93a6-4799b319d18a.png)

Explaining: each array will generate a column in the collectionView, being that each column will follow its cellsStyle pattern. So the first column, in this case, will draw the sequence `[.Medium, .Small, .Medium]` repeatedly while it necessary.

The MozaicLayout will generate a column for each array you pass, so you don't have any limitations here about the minimum or the maximum number of columns. Be careful about that, please!

The sizes of the cells are based on the column width and on the number of columns. 
`LargeCellWidth = collectionViewContentWidth / numberOfColumns`

### Optional Methods

Mozaic offers these optional methods too.

```swift

func setCellHeightProportion() -> CGFloat                 //Default return = 1.0

func setHorizontalSpaceBetweenCells() -> CGFloat          //Default return = 15.0

func setVerticalSpaceBetweenCells() -> CGFloat            //Default return = 15.0

```

![spaces](https://user-images.githubusercontent.com/23136843/45269526-fdf21f00-b465-11e8-9adc-fda5c1ef04b9.png)

## Author

Lucca França Gomes Ferreira - luccafgf - lfgf@cin.ufpe.br

## License

Mozaic is available under the MIT license. See the LICENSE file for more info.

