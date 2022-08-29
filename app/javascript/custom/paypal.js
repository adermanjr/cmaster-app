function paypal_plan_id(currency, reactivate) {
    if (currency == 'BRL') {
        if (reactivate == 'true')
            return PAYPAL_CODE_BRL_DIRECT;
        else
            return PAYPAL_CODE_BRL;
    }
    else if (currency == 'USD') {
        if (reactivate == 'true')
            return PAYPAL_CODE_USD_DIRECT;
        else
            return PAYPAL_CODE_USD;
    }
    else {
        if (reactivate == 'true')
            return PAYPAL_CODE_EUR_DIRECT;
        else
            return PAYPAL_CODE_EUR;
    }
}
const PAYPAL_CODE_BRL = 'P-76751176D5615502FL22BMSA';
const PAYPAL_CODE_USD = 'P-0C6261323E293452EL22BPQY';
const PAYPAL_CODE_EUR = 'P-5DB146754X7671158L22BR5Q';

const PAYPAL_CODE_BRL_DIRECT = 'P-11H5024467050774CL3LF5HI';
const PAYPAL_CODE_USD_DIRECT = 'P-1YK76843RE9503109L3LF7WQ';
const PAYPAL_CODE_EUR_DIRECT = 'P-0FE92020SK922800ML3LGAVA';

function createHidden(name, value, origin) {
  let input = document.createElement("input");
  input.setAttribute("type", "hidden");
  input.setAttribute("name", name);
  input.setAttribute("value", value);
  
  document.querySelector(origin).appendChild(input);
}

function removeHidden(name) {
  let element = document.querySelector("input[type='hidden'][name='`name`']")
  if (element != null) element.parentNode.removeChild(element);
}

function submit_plan_free(tipo_plano) {
  createHidden('plano', tipo_plano, '.edit_usuario');
  createHidden("cancelado", false, ".edit_usuario");
  document.querySelector(".edit_usuario").submit();
}