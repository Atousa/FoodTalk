/**
 * Copyright IBM Corporation 2015
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 **/

import Foundation
import ObjectMapper

extension LanguageTranslation {

    /// An identifiable language
    public struct IdentifiableLanguage: Mappable {
        
        /// The language
        public var language:String?
        
        /// The name
        public var name:String?

        /// Used internally to initialize an `IdentifiableLanguage` from JSON.
        public init?(_ map: Map) {}

        /// Used internally to serialize and deserialize JSON.
        public mutating func mapping(map: Map) {
            language    <- map["language"]
            name        <- map["name"]
        }
    }
}