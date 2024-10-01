// document.addEventListener('DOMContentLoaded', function() {
//   // Call the toggleFields function to initialize on page load
//   toggleFields();

//   var planTypeField = document.getElementById('plan_type');

//   if (planTypeField) {
//     planTypeField.addEventListener('change', toggleFields);
//   }

//   function toggleFields() {
//     var planType = document.getElementById('plan_type').value;

//     // If the plan type is free, hide price and discount-related fields
//     if (planType === 'free') {
//       hideField('price_monthly');
//       hideField('price_yearly');
//       hideField('discount');
//       hideField('discount_type');
//       hideField('discount_percentage');
//     } else {
//       showField('price_monthly');
//       showField('price_yearly');
//       showField('discount');
//       showField('discount_type');
//       showField('discount_percentage');
//     }
//   }

//   function hideField(fieldId) {
//     var field = document.getElementById('plan_' + fieldId).closest('.input');
//     if (field) field.style.display = 'none';
//   }

//   function showField(fieldId) {
//     var field = document.getElementById('plan_' + fieldId).closest('.input');
//     if (field) field.style.display = '';
//   }
// });