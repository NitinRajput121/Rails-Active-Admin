//= require active_admin/base
//= require active_admin_flat_skin

// document.addEventListener('DOMContentLoaded', function() {
//   var planTypeField = document.getElementById('plan_plan_type'); // Correct ID

//   if (planTypeField) {
//     planTypeField.addEventListener('change', toggleFields);
//     toggleFields(); // Initialize visibility based on the current selection
//   }

//   function toggleFields() {
//     var planType = document.getElementById('plan_plan_type').value; // Correct ID

//     // If the plan type is free, hide price and discount-related fields
//     if (planType === 'free') {
//       hideField('price_monthly');
//       hideField('price_yearly');
//       hideField('discount');
//       hideField('discount_type');
//       hideField('discount_percentage');
//     } else { // If the plan type is paid
//       showField('price_monthly');
//       showField('price_yearly');
//       showField('discount');
//       showField('discount_type');
//       showField('discount_percentage');
//     }
//   }

//   function hideField(fieldId) {
//     var field = document.getElementById('plan_' + fieldId); // Get the field by ID
//     if (field) {
//       field.closest('.input').style.display = 'none'; // Hide the input container
//     }
//   }

//   function showField(fieldId) {
//     var field = document.getElementById('plan_' + fieldId); // Get the field by ID
//     if (field) {
//       field.closest('.input').style.display = ''; // Show the input container
//     }
//   }
// });

document.addEventListener('DOMContentLoaded', function() {
  var planTypeField = document.getElementById('plan_plan_type'); // Plan Type
  var discountField = document.getElementById('plan_discount'); // Discount Field

  if (planTypeField) {
    planTypeField.addEventListener('change', toggleFields);
    toggleFields(); // Initialize visibility based on the current selection
  }

  if (discountField) {
    discountField.addEventListener('change', toggleDiscountFields);
    toggleDiscountFields(); // Initialize visibility based on the current selection
  }

  // Function to toggle price and discount fields based on plan_type
  function toggleFields() {
    var planType = planTypeField.value; // Get current plan type value

    if (planType === 'free') {
      hideField('price_monthly');
      hideField('price_yearly');
      hideField('discount');
      hideField('discount_type');
      hideField('discount_percentage');
    } else { // If plan type is 'paid'
      showField('price_monthly');
      showField('price_yearly');
      showField('discount');
      // Call the discount toggle function to check discount field state
      toggleDiscountFields();
    }
  }

  // Function to toggle discount_type and discount_percentage based on discount field value
  function toggleDiscountFields() {
    var discount = discountField.value; // Get current discount value ("true" or "false")

    if (discount === 'true') { // Show discount_type and discount_percentage only if discount is "Yes"
      showField('discount_type');
      showField('discount_percentage');
    } else {
      hideField('discount_type');
      hideField('discount_percentage');
    }
  }

  // Helper function to hide a field
  function hideField(fieldId) {
    var field = document.getElementById('plan_' + fieldId); // Get the field by ID
    if (field) {
      field.closest('.input').style.display = 'none'; // Hide the input container
    }
  }

  // Helper function to show a field
  function showField(fieldId) {
    var field = document.getElementById('plan_' + fieldId); // Get the field by ID
    if (field) {
      field.closest('.input').style.display = ''; // Show the input container
    }
  }
});



  // document.addEventListener('DOMContentLoaded', function() {
  //         var priceMonthlyField = document.getElementById('plan_price_monthly');
  //         var priceYearlyField = document.getElementById('plan_price_yearly');
  //         var discountTypeField = document.getElementById('plan_discount_type');
  //         var discountPercentageField = document.getElementById('plan_discount_percentage');
  //         var discountField = document.getElementById('plan_discount');
  //         var discountedPriceMonthlyField = document.getElementById('discounted_price_monthly');
  //         var discountedPriceYearlyField = document.getElementById('discounted_price_yearly');

  //         // Add event listeners to update discounted prices on field changes
  //         [priceMonthlyField, priceYearlyField, discountTypeField, discountPercentageField, discountField].forEach(function(field) {
  //           field.addEventListener('input', calculateDiscountedPrices);
  //         });

  //         function calculateDiscountedPrices() {
  //           var priceMonthly = parseFloat(priceMonthlyField.value) || 0;
  //           var priceYearly = parseFloat(priceYearlyField.value) || 0;
  //           var discountPercentage = parseFloat(discountPercentageField.value) || 0;
  //           var discountType = discountTypeField.value;
  //           var hasDiscount = discountField.value === 'true';

  //           // Calculate discounted prices
  //           var discountedPriceMonthly = priceMonthly;
  //           var discountedPriceYearly = priceYearly;

  //           if (hasDiscount) {
  //             if (discountType === 'Percentage') {
  //               discountedPriceMonthly = priceMonthly - (priceMonthly * (discountPercentage / 100));
  //               discountedPriceYearly = priceYearly - (priceYearly * (discountPercentage / 100));
  //             } else if (discountType === 'Fixed') {
  //               discountedPriceMonthly = priceMonthly - discountPercentage;
  //               discountedPriceYearly = priceYearly - discountPercentage;
  //             }
  //           }

  //           // Update the read-only fields
  //           discountedPriceMonthlyField.value = discountedPriceMonthly.toFixed(2);
  //           discountedPriceYearlyField.value = discountedPriceYearly.toFixed(2);
  //         }

  //         // Initial calculation
  //         // calculateDiscountedPrices();
  //       });


document.addEventListener('DOMContentLoaded', function() {
  var priceMonthlyField = document.getElementById('plan_price_monthly');
  var priceYearlyField = document.getElementById('plan_price_yearly');
  var discountTypeField = document.getElementById('plan_discount_type');
  var discountPercentageField = document.getElementById('plan_discount_percentage');
  var discountField = document.getElementById('plan_discount');

  // Create placeholders for displaying discounted prices
  var discountedPriceMonthlyDisplay = document.createElement('div');
  var discountedPriceYearlyDisplay = document.createElement('div');
  discountedPriceMonthlyDisplay.id = 'display_discounted_price_monthly';
  discountedPriceYearlyDisplay.id = 'display_discounted_price_yearly';
  discountedPriceMonthlyDisplay.style.fontWeight = 'bold';
  discountedPriceYearlyDisplay.style.fontWeight = 'bold';

  // Append the displays outside the form, for example, after the form
  var formElement = document.querySelector('form'); // Select the form
  formElement.parentNode.insertBefore(discountedPriceMonthlyDisplay, formElement.nextSibling);
  formElement.parentNode.insertBefore(discountedPriceYearlyDisplay, discountedPriceMonthlyDisplay.nextSibling);

  // Add event listeners to update discounted prices on field changes
  [priceMonthlyField, priceYearlyField, discountTypeField, discountPercentageField, discountField].forEach(function(field) {
    field.addEventListener('input', calculateDiscountedPrices);
  });

  function calculateDiscountedPrices() {
    var priceMonthly = parseFloat(priceMonthlyField.value) || 0;
    var priceYearly = parseFloat(priceYearlyField.value) || 0;
    var discountPercentage = parseFloat(discountPercentageField.value) || 0;
    var discountType = discountTypeField.value;
    var hasDiscount = discountField.value === 'true';

    // Calculate discounted prices
    var discountedPriceMonthly = priceMonthly;
    var discountedPriceYearly = priceYearly;

    if (hasDiscount) {
      if (discountType === 'Percentage') {
        discountedPriceMonthly = priceMonthly - (priceMonthly * (discountPercentage / 100));
        discountedPriceYearly = priceYearly - (priceYearly * (discountPercentage / 100));
      } else if (discountType === 'Fixed') {
        discountedPriceMonthly = priceMonthly - discountPercentage;
        discountedPriceYearly = priceYearly - discountPercentage;
      }
    }

    // Update the display elements
    discountedPriceMonthlyDisplay.textContent = `Discounted Price Monthly: ${discountedPriceMonthly.toFixed(2)}`;
    discountedPriceYearlyDisplay.textContent = `Discounted Price Yearly: ${discountedPriceYearly.toFixed(2)}`;
  }

  // Initial calculation
  calculateDiscountedPrices();
});


