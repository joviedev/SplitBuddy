//
//  bill_splitting.md
//  
//
//  Created by Jovie  on 13/10/2024.
//

import Foundation

# Bill Splitting

In **SplitBuddy**, you can split a bill among a group of people in two primary ways:
1. **Equally**: Each person pays an equal share of the total.
2. **By Items**: Each person pays only for the items they consumed.

## Split Equally

When a bill is split equally, the total amount (including tax) is divided by the number of people involved in the bill. Each person will owe the same amount regardless of the individual items consumed.

### Example

Let’s say you have a dinner bill with the following items:
- Pizza: $15.00
- Pasta: $12.00
- Drinks: $8.00

If there are 3 people, the total amount is $35.00. Each person will owe:
Total = (15 + 12 + 8) = $35.00 Each person = 35 / 3 = $11.67

## Split by Items

When splitting a bill by items, each person pays only for the food or drinks they ordered. The app keeps track of who ordered what and calculates the final amount for each individual.

### Example

Let’s use the same items from above, but each person orders differently:
- Person 1 orders the Pizza.
- Person 2 orders the Pasta.
- Person 3 orders the Drinks.

In this case, Person 1 will owe $15.00, Person 2 will owe $12.00, and Person 3 will owe $8.00. Tax can also be applied proportionally based on their individual totals.

## Tax Calculation

Taxes are applied after calculating the total bill. SplitBuddy allows you to set a tax percentage, and it automatically adds it to each individual’s share.

If tax = 10% Total tax = 35 * 0.10 = $3.50 Each person (equal split) = (35 + 3.50) / 3 = $12.17


 [Back to Documentation](./SplitBuddy.tutorial)
