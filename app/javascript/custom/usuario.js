function submit_plan_free(tipo_plano) {
    createHidden('plano', tipo_plano, '.edit_usuario');
    createHidden("cancelado", false, ".edit_usuario");
    document.querySelector(".edit_usuario").submit();
}