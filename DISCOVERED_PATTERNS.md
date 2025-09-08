# DNSDataObjects - Discovered Patterns & Lessons Learned

## Overview
This document captures key insights discovered during the initial test implementation attempt, to help the next developer avoid common pitfalls.

## Critical Property Mapping Discoveries

### ✅ Confirmed DAO Structures (Source-Verified):

#### DAOPricingTier (Sources/DNSDataObjects/DAOPricingTier.swift)
**Actual Properties:**
```swift
open var dataStrings: [String: DNSString] = [:]
open var overrides: [DAOPricingOverride] = []
open var priority: Int = DNSPriority.normal
open var seasons: [DAOPricingSeason] = []
open var title: String = ""
open var price: DNSPrice? { price() }  // Computed - READ ONLY
```

**❌ Properties That DON'T Exist (were assumed in failed tests):**
- `name` (use `title` instead)
- `level`, `minQuantity`, `maxQuantity`
- `unitPrice`, `discountPercent`
- `description` (use `title` or `dataStrings`)

#### DAOPricingPrice (Source-Verified)
**Actual Properties:**
```swift
open var prices: [DNSPrice] = []
// And inherited from DAOBaseObject: id, meta
```

**❌ Properties That DON'T Exist:**
- `amount`, `currency`, `interval`, `intervalCount`, `trialPeriodDays`

### 🔍 Pattern Recognition Rules:

1. **Title vs Name**: Most DAOs use `title: String`, not `name: DNSString`
2. **Computed Properties**: Many price-related properties are computed/read-only
3. **Collections**: Most relationships are arrays: `[DAORelatedClass]`
4. **Priority Pattern**: Many DAOs have `priority: Int` from DNSPriority
5. **DataStrings Pattern**: Complex DAOs use `dataStrings: [String: DNSString]` for localized content

## API Patterns Discovered

### DNSString vs String
```swift
// DNSString (localized)
open var localizedTitle: DNSString = DNSString()
localizedTitle.asString  // Get current language string
localizedTitle = DNSString(with: "English Text")

// String (simple)
open var title: String = ""
title = "Simple String"
```

### DNSURL vs URL
```swift
// DNSURL (localized URLs)
open var url: DNSURL = DNSURL()
url.asURL  // Returns Optional<URL>
url.isEmpty // Check if empty

// Not url.url - this was wrong!
```

### DNSVisibility Enum (Source-Verified)
```swift
public enum DNSVisibility: String, CaseIterable, Codable {
    case adultsOnly
    case everyone  
    case staffYouth
    case staffOnly
    case adminOnly
}

// ❌ These DON'T exist: .none, .public, .private, .members
```

### ID Property Pattern
```swift
// ❌ WRONG - causes "cannot assign to value: 'id' is a method"
object.id = "test-id"

// ✅ CORRECT - use initializer
let object = DAOClassName(id: "test-id")
// OR
let object = DAOClassName()
// id is auto-generated
```

## Mac Catalyst Compilation Patterns

### Platform Dependencies Issue (RESOLVED)
The issue was AnimatedField requiring macOS 10.13 while DNSCore requires macOS 13.0:
```swift
// Fixed in Package.swift by ensuring platform consistency
platforms: [
    .iOS(.v16),
    .tvOS(.v16),
    // .macOS(.v13),  // Commented out initially
    .watchOS(.v9),
]
```

### Sorting API Changes
```swift
// ❌ OLD (causes compilation errors)
array.sorted(using: comparator)

// ✅ NEW  
array.sorted(by: { $0.property < $1.property })
```

## DAOTestHelpers Framework (Already Working)

### Available Helper Methods:
```swift
// Protocol compliance validation
try DAOTestHelpers.validateCodableRoundtrip(object)
try DAOTestHelpers.validateDictionaryRoundtrip(object)
DAOTestHelpers.validateCopying(original, copy)
DAOTestHelpers.validateIsDiffFrom(obj1, obj2)

// Memory and performance
DAOTestHelpers.validateNoMemoryLeaks { 
    MockDAOFactory.createMock() 
}

// Mock data creation
DAOTestHelpers.createMockDNSMetadata(status: "active")
```

### MockDAOFactory Protocol (Working Pattern):
```swift
protocol MockDAOFactory {
    associatedtype DAOType
    
    static func createMock() -> DAOType
    static func createMockWithTestData() -> DAOType  
    static func createMockWithEdgeCases() -> DAOType
    static func createMockArray(count: Int) -> [DAOType]
}
```

## Common Compilation Error Patterns & Fixes

### 1. Property Assignment Type Mismatches
```swift
// ❌ Wrong
request.title = DNSString(with: "Test")  // title is String, not DNSString

// ✅ Correct  
request.title = "Test"  // Use String directly
```

### 2. Optional Unwrapping
```swift
// ❌ Wrong
XCTAssertEqual(object.optionalProperty, expectedValue)

// ✅ Correct
XCTAssertEqual(object.optionalProperty ?? defaultValue, expectedValue)
// OR
XCTAssertEqual(object.optionalProperty, expectedValue)  // If both optional
```

### 3. Read-Only Property Assignments
```swift
// ❌ Wrong
tier.price = DNSPrice()  // price is computed/read-only

// ✅ Correct  
// Don't assign to computed properties - test their values instead
XCTAssertNotNil(tier.price)
```

## Successful Test File Structure (Template)

```swift
import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

final class DAOClassNameTests: XCTestCase {
    
    struct MockDAOClassNameFactory: MockDAOFactory {
        typealias DAOType = DAOClassName
        
        static func createMock() -> DAOClassName {
            let object = DAOClassName(id: "test-id")
            // Set only properties that actually exist
            object.title = "Test Title"
            object.enabled = true
            return object
        }
        
        static func createMockWithTestData() -> DAOClassName {
            let object = DAOClassName(id: "detailed-test-id")
            object.title = "Detailed Test"
            // Add more realistic test data
            return object
        }
        
        static func createMockWithEdgeCases() -> DAOClassName {
            let object = DAOClassName()
            // Test edge cases - empty strings, nil values, etc.
            object.title = ""
            return object
        }
        
        static func createMockArray(count: Int) -> [DAOClassName] {
            return (0..<count).map { index in
                let object = DAOClassName(id: "test-\(index)")
                object.title = "Item \(index)"
                return object
            }
        }
    }
    
    func testDefaultInitialization() {
        let object = DAOClassName()
        XCTAssertNotNil(object.id)
        XCTAssertEqual(object.title, "")
        // Test other default values
    }
    
    func testCodableRoundTrip() throws {
        let original = MockDAOClassNameFactory.createMockWithTestData()
        try DAOTestHelpers.validateCodableRoundtrip(original)
    }
    
    func testMemoryManagement() {
        DAOTestHelpers.validateNoMemoryLeaks {
            MockDAOClassNameFactory.createMockWithTestData()
        }
    }
    
    static var allTests = [
        ("testDefaultInitialization", testDefaultInitialization),
        ("testCodableRoundTrip", testCodableRoundTrip),
        ("testMemoryManagement", testMemoryManagement),
    ]
}
```

## Property Discovery Methodology

### Step 1: Examine Source File
```bash
# Find the DAO class
find Sources -name "*ClassName*.swift"

# Look for properties section  
grep -A 20 "// MARK: - Properties" Sources/DNSDataObjects/DAOClassName.swift
```

### Step 2: Document Properties
For each property found, document:
- Name and type
- Read-write or computed
- Default value
- Any validation logic
- Relationships to other DAOs

### Step 3: Avoid Assumptions
Never assume a property exists based on:
- Similar classes in other frameworks
- Logical expectations
- Variable names in business logic

Always verify in source code first!

## Final Recommendations

### For the New Developer:
1. **Start small** - Pick 1-2 simple DAOs and perfect them first
2. **Verify everything** - Check source code for every property
3. **Use the working patterns** - DAOTestHelpers framework is solid  
4. **Test incrementally** - Compile frequently to catch errors early
5. **Document discoveries** - Update this file as you learn more

### Red Flags to Watch For:
- ❌ "Cannot assign to value: 'id' is a method"
- ❌ "Value of type 'DAOClass' has no member 'property'"  
- ❌ "Cannot assign value of type 'DNSString' to type 'String'"
- ❌ "Value of optional type must be unwrapped"

These indicate property discovery or type mapping issues.

## Success Indicators:
- ✅ Mac Catalyst compilation with 0 errors
- ✅ Tests actually test real functionality  
- ✅ MockDAOFactory creates valid test objects
- ✅ All protocol compliance tests pass
- ✅ Memory management tests pass
- ✅ Meaningful test coverage numbers