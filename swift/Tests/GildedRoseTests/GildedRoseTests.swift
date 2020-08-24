@testable import GildedRose
import XCTest

class GildedRoseTests: XCTestCase {

    func testRegularEmptyItem() {
        let itemName = "Elixir"
        var sellInValue = 0
        let emptyItem = Item(name: itemName, sellIn: sellInValue, quality: 0)
        let app = GildedRose(items: [emptyItem])
        
        /// repeatCount can be changed to any values > 1 to check the common logic, more information https://en.wikipedia.org/wiki/Mathematical_induction
        let repeatCount = 100
        for n in 1...repeatCount + 1 {
            app.updateQuality()
            sellInValue -= 1
            if n == 1 {
                XCTAssertEqual(itemName, app.items[0].name, "The name was not changed")
                XCTAssertEqual(0, app.items[0].quality, "The Quality of an item is never negative")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased")
            }
            if n == repeatCount {
                XCTAssertEqual(itemName, app.items[0].name, "The name was not changed, \(repeatCount) iteration")
                XCTAssertEqual(0, app.items[0].quality, "The Quality of an item is never negative, \(repeatCount) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount) iteration")
            }
            if n == repeatCount + 1 {
                XCTAssertEqual(itemName, app.items[0].name, "The name was not changed, \(repeatCount + 1) iteration")
                XCTAssertEqual(0, app.items[0].quality, "The Quality of an item is never negative, \(repeatCount + 1) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount + 1) iteration")
            }
        }
    }
    
    func testRegularItem() {
        let itemName = "Elixir"
        var sellInValue = 10
        var qualityValue = 20
        let item = Item(name: itemName, sellIn: sellInValue, quality: qualityValue)
        let app = GildedRose(items: [item])
        let repeatCount = 100
        for n in 1...repeatCount + 1 {
            app.updateQuality()
            sellInValue -= 1
            qualityValue -= 1
            if sellInValue < 0 {
                qualityValue -= 1 // Once the sell by date has passed, Quality degrades twice as fast
            }
            if qualityValue < 0 {
                qualityValue = 0 // The Quality of an item is never negative
            }
            if n == 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was decreased")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased")
            }
            if n == repeatCount {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was decreased + never negative, \(repeatCount) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount) iteration")
            }
            if n == repeatCount + 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was decreased + never negative, \(repeatCount + 1) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount + 1) iteration")
            }
        }
    }
    
    func testAgedBrieItem() {
        let itemName = "Aged Brie"
        var sellInValue = 10
        var qualityValue = 0
        let item = Item(name: itemName, sellIn: sellInValue, quality: qualityValue)
        let app = GildedRose(items: [item])
        let middleCheckIteration = sellInValue - 2
        let repeatCount = 100
        for n in 1...repeatCount + 1 {
            app.updateQuality()
            sellInValue -= 1
            qualityValue += 1
            if qualityValue > 50 {
                qualityValue = 50
            }
            if n == 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased")
            }
            if n == middleCheckIteration {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased properly, \(n) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(n) iteration")
            }
            if n == repeatCount {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased + never more than 50, \(repeatCount) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount) iteration")
            }
            if n == repeatCount + 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased but never more than 50, \(repeatCount + 1) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount + 1) iteration")
            }
        }
    }
    
    func testBackstagePassesItem() {
        let itemName = "Backstage passes to a TAFKAL80ETC concert"
        var sellInValue = 15
        var qualityValue = 20
        let item = Item(name: itemName, sellIn: sellInValue, quality: qualityValue)
        let app = GildedRose(items: [item])
        let middleCheckIteration = sellInValue - 3
        let sellInIteration = sellInValue
        let repeatCount = 100
        for n in 1...repeatCount + 1 {
            app.updateQuality()
            sellInValue -= 1
            qualityValue += 1
            if sellInValue < 10 {
                qualityValue += 1 // Quality increases by 2 when there are 10 days or less
            }
            if sellInValue < 5 {
                qualityValue += 1 // // Quality increases by 3 when there are 5 days or less
            }
            if sellInValue < 0 {
                qualityValue = 0
            }
            if qualityValue > 50 {
                qualityValue = 50
            }
            if n == 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased")
            }
            if n == middleCheckIteration {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased properly, \(n) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(n) iteration")
            }
            if n == sellInIteration {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was reset properly, \(n) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(n) iteration")
            }
            if n == repeatCount {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased + never more than 50, \(repeatCount) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount) iteration")
            }
            if n == repeatCount + 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was increased but never more than 50, \(repeatCount + 1) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount + 1) iteration")
            }
        }
    }
    
    func testSulfurasItem() {
        let itemName = "Sulfuras, Hand of Ragnaros"
        let sellInValue = -1
        let qualityValue = 80
        let item = Item(name: itemName, sellIn: sellInValue, quality: qualityValue)
        let app = GildedRose(items: [item])
        let repeatCount = 100
        for n in 1...repeatCount + 1 {
            app.updateQuality()
            if n == 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an Sulfuras state constant")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "The sellIn is constant for Sulfuras")
            }
            if n == repeatCount {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an Sulfuras state constant, \(repeatCount) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "The sellIn is constant for Sulfuras, \(repeatCount) iteration")
            }
            if n == repeatCount + 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an Sulfuras state constant, \(repeatCount) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "The sellIn is constant for Sulfuras, \(repeatCount + 1) iteration")
            }
        }
    }
    
    func testConjuredItem() {
        let itemName = "Conjured Mana Cake"
        var sellInValue = 3
        var qualityValue = 6
        let item = Item(name: itemName, sellIn: sellInValue, quality: qualityValue)
        let app = GildedRose(items: [item])
        let repeatCount = 100
        for n in 1...repeatCount + 1 {
            app.updateQuality()
            sellInValue -= 1
            qualityValue -= 2  // "Conjured" items degrade in Quality twice as fast as normal items
            if sellInValue < 0 {
                qualityValue -= 2 // "Conjured" items degrade in Quality twice as fast as normal items
            }
            if qualityValue < 0 {
                qualityValue = 0 // The Quality of an item is never negative
            }
            if n == 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was decreased")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased")
            }
            if n == repeatCount {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was decreased + never negative, \(repeatCount) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount) iteration")
            }
            if n == repeatCount + 1 {
                XCTAssertEqual(qualityValue, app.items[0].quality, "The Quality of an item was decreased + never negative, \(repeatCount + 1) iteration")
                XCTAssertEqual(sellInValue, app.items[0].sellIn, "sellIn was decreased, \(repeatCount + 1) iteration")
            }
        }
    }
    

    static var allTests : [(String, (GildedRoseTests) -> () throws -> Void)] {
        return [
            ("testRegularEmpty", testRegularEmptyItem),
            ("testRegular", testRegularItem),
            ("testAgedBrie", testAgedBrieItem),
            ("testBackstagePasses", testBackstagePassesItem),
            ("testSulfuras", testSulfurasItem),
            ("testConjured", testConjuredItem),
        ]
    }
}
