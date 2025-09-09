//
//  MockDAOProductFactory.swift
//  DoubleNode Swift Framework (DNSFramework) - DNSDataObjectsTests
//
//  Created by Darren Ehlers.
//  Copyright (c) 2025 - 2016 DoubleNode.com. All rights reserved.
//

import XCTest
import DNSCore
import DNSDataTypes
@testable import DNSDataObjects

// MARK: - MockDAOProductFactory -
struct MockDAOProductFactory: MockDAOFactory {
    typealias DAOType = DAOProduct
    
    static func createMock() -> DAOProduct {
        let product = DAOProduct()
        product.title = DNSString(with: "Mock Product")
        product.about = DNSString(with: "Mock product description")
        product.sku = "MOCK-SKU-123"
        return product
    }
    
    static func createMockWithTestData() -> DAOProduct {
        let product = DAOProduct(id: "product_test_data")
        product.title = DNSString(with: "Test Product")
        product.about = DNSString(with: "Detailed test product description")
        product.sku = "TEST-SKU-456"
        
        // Create test pricing
        let pricing = DAOPricing()
        pricing.id = "pricing_test"
        product.pricing = pricing
        
        // Create test media items
        let media1 = DAOMedia()
        media1.id = "media_1"
        let media2 = DAOMedia()
        media2.id = "media_2"
        product.mediaItems = [media1, media2]
        
        return product
    }
    
    static func createMockWithEdgeCases() -> DAOProduct {
        let product = DAOProduct()
        
        // Edge cases
        product.title = DNSString() // Empty title
        product.about = DNSString() // Empty about
        product.sku = "" // Empty SKU
        product.mediaItems = [] // No media items
        product.pricing = DAOPricing() // Empty pricing (initialized by default)
        
        return product
    }
    
    static func createMockArray(count: Int) -> [DAOProduct] {
        var products: [DAOProduct] = []
        
        for i in 0..<count {
            let product = DAOProduct()
            product.id = "product\(i)" // Set explicit ID to match test expectations
            product.title = DNSString(with: "Product \(i + 1)")
            product.about = DNSString(with: "Description for product \(i + 1)")
            product.sku = "SKU-\(String(format: "%03d", i + 1))"
            
            // Add variety
            if i % 2 == 0 {
                let pricing = DAOPricing()
                pricing.id = "pricing_\(i + 1)"
                product.pricing = pricing
            }
            
            if i % 3 == 0 {
                let media = DAOMedia()
                media.id = "media_\(i + 1)"
                product.mediaItems = [media]
            }
            
            products.append(product)
        }
        
        return products
    }
    
    // Legacy methods for backward compatibility
    static func create() -> DAOProduct {
        return createMockWithTestData()
    }
    
    static func createEmpty() -> DAOProduct {
        return createMockWithEdgeCases()
    }
    
    static func createWithId(_ id: String) -> DAOProduct {
        let product = createMockWithTestData()
        product.id = id
        return product
    }
}