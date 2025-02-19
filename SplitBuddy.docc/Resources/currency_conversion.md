//
//  currency_conversion.md
//  
//
//  Created by Jovie  on 13/10/2024.
//

import Foundation

# Currency Conversion

SplitBuddy supports splitting bills across different currencies. This is particularly useful if people in your group are paying in different currencies. The app uses **real-time exchange rates** to ensure accurate conversions.

## ExchangeRatesTools

`ExchangeRatesTools` is the utility in SplitBuddy that fetches the latest exchange rates from the web and applies them to the bill. The exchange rate API ensures you have up-to-date rates for all major global currencies.

### Example Use Case

Suppose you are splitting a bill between two people:
- Person 1 is paying in **USD**.
- Person 2 is paying in **EUR**.

If the total bill is $100, and the conversion rate is 1 USD = 0.85 EUR, the app will calculate Person 2’s share based on the current exchange rate.
Person 2 (in EUR) = (50 USD) * 0.85 = 42.50 EUR


### How to Apply Currency Conversion

To use currency conversion:
1. Input the total bill in the main currency.
2. Choose the currency for each person in the group.
3. The app will automatically apply the conversion rates and update the total.

### Supported Currencies

SplitBuddy supports all major currencies, including:
- USD (US Dollar)
- EUR (Euro)
- GBP (British Pound)
- AUD (Australian Dollar)
- JPY (Japanese Yen)

[Back to Documentation](./SplitBuddy.tutorial)
