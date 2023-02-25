import XCTest
import ExampleMain

class ApiUrlBuilderTest: XCTestCase {
    private var builder: ApiUrlBuilder!
    
    override func setUp() {
        builder = ApiUrlBuilder("https://api.com")
    }
    
    override func tearDown() {
         builder = nil
    }

    func testThatProvidesValidUrlWhenAddsPathComponent() {
        // Arrange
        
        // Act
        _ = builder.addPath(path: "measurements")
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsOneMorePathComponent() {
        // Arrange
        _ = builder.addPath(path: "v1")
        
        // Act
        _ = builder.addPath(path: "measurements")
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/v1/measurements"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithNoValue() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addItem(name: "lastDay", value: nil)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?lastDay"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithIntValue() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addItem(name: "timestamp", value: 1234)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?timestamp=1234"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithIntFloat() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addItem(name: "timestamp", value: 12.34)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?timestamp=12.34"
        )
    }
    
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithStringValue() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addItem(name: "timestamp", value: "1234")
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?timestamp=1234"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsQueryItemWithBoolValue() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addItem(name: "timestamp", value: true)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?timestamp=true"
        )
    }
    
    func testThatProvidesValidUrlWhenAddsSomeQueryItems() {
        // Arrange
        _ = builder.addPath(path: "measurements")
        
        // Act
        _ = builder.addItem(name: "timestamp", value: 11123)
        _ = builder.addItem(name: "lastDay", value: true)
        
        // Assert
        XCTAssertEqual(
            builder.url().absoluteString,
            "https://api.com/measurements?timestamp=11123&lastDay=true"
        )
    }
}

