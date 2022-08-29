# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2020_06_04_184307) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "aplicacaos", id: :serial, force: :cascade do |t|
    t.integer "tratamento_id"
    t.integer "pombo_id"
    t.datetime "dtaplicacao", precision: nil
    t.float "dosagem"
    t.string "medida"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "pt_id"
    t.index ["pombo_id"], name: "index_aplicacaos_on_pombo_id"
    t.index ["tratamento_id"], name: "index_aplicacaos_on_tratamento_id"
  end

  create_table "clubes", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "idregistro"
    t.string "email"
    t.string "logradouro"
    t.string "complemento"
    t.string "bairro"
    t.integer "cep"
    t.string "tel1"
    t.string "tel2"
    t.string "contato"
    t.integer "estado_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "cidade"
    t.bigint "nacao_id"
    t.index ["estado_id"], name: "index_clubes_on_estado_id"
    t.index ["nacao_id"], name: "index_clubes_on_nacao_id"
  end

  create_table "competicaos", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.integer "ano"
    t.integer "clb_id"
    t.integer "est_id"
    t.integer "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["usuario_id"], name: "index_competicaos_on_usuario_id"
  end

  create_table "cors", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "equipes", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "usuario_id"
    t.index ["usuario_id"], name: "index_equipes_on_usuario_id"
  end

  create_table "equipes_pombos", id: false, force: :cascade do |t|
    t.integer "equipe_id"
    t.integer "pombo_id"
    t.index ["equipe_id"], name: "index_equipes_pombos_on_equipe_id"
    t.index ["pombo_id"], name: "index_equipes_pombos_on_pombo_id"
  end

  create_table "estados", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.integer "nacao_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["nacao_id"], name: "index_estados_on_nacao_id"
  end

  create_table "nacaos", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "sigla"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "locale"
  end

  create_table "planos", id: :serial, force: :cascade do |t|
    t.string "tipo"
    t.datetime "dtinicio_pagto", precision: nil
    t.datetime "dtcancelamento", precision: nil
    t.float "valor_mensal"
    t.string "moeda"
    t.string "id_recorrencia_operadora"
    t.string "url_recorrencia_operadora"
    t.integer "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["usuario_id"], name: "index_planos_on_usuario_id"
  end

  create_table "pombal_tratamentos", id: :serial, force: :cascade do |t|
    t.integer "pombal_id"
    t.integer "tratamento_id"
    t.datetime "dtinicio", precision: nil
    t.datetime "dtfim", precision: nil
    t.boolean "lembrar"
    t.integer "qtde"
    t.string "intervalo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["pombal_id"], name: "index_pombal_tratamentos_on_pombal_id"
    t.index ["tratamento_id"], name: "index_pombal_tratamentos_on_tratamento_id"
  end

  create_table "pombals", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.datetime "dtdesativ", precision: nil
    t.integer "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["usuario_id"], name: "index_pombals_on_usuario_id"
  end

  create_table "pombals_pombos", id: false, force: :cascade do |t|
    t.integer "pombal_id"
    t.integer "pombo_id"
    t.index ["pombal_id"], name: "index_pombals_pombos_on_pombal_id"
    t.index ["pombo_id"], name: "index_pombals_pombos_on_pombo_id"
  end

  create_table "pombos", id: :serial, force: :cascade do |t|
    t.string "anilha"
    t.string "nome"
    t.datetime "dtnasc", precision: nil
    t.string "sexo"
    t.integer "cor_id"
    t.integer "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.boolean "vivo", default: true
    t.integer "pai_id"
    t.integer "mae_id"
    t.string "linhagem"
    t.string "desc_cor"
    t.index ["cor_id"], name: "index_pombos_on_cor_id"
    t.index ["id", "mae_id"], name: "index_pombos_on_id_and_mae_id", unique: true
    t.index ["id", "pai_id"], name: "index_pombos_on_id_and_pai_id", unique: true
    t.index ["usuario_id"], name: "index_pombos_on_usuario_id"
  end

  create_table "preparos", force: :cascade do |t|
    t.string "nome"
    t.string "descricao"
    t.integer "tipo_prova"
    t.bigint "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["usuario_id"], name: "index_preparos_on_usuario_id"
  end

  create_table "prova_preparos", force: :cascade do |t|
    t.bigint "prova_id"
    t.bigint "preparo_id"
    t.bigint "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["preparo_id"], name: "index_prova_preparos_on_preparo_id"
    t.index ["prova_id"], name: "index_prova_preparos_on_prova_id"
    t.index ["usuario_id"], name: "index_prova_preparos_on_usuario_id"
  end

  create_table "provas", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.datetime "dtsolta", precision: nil
    t.integer "tipo"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "competicao_id"
    t.integer "usuario_id"
    t.string "lat"
    t.string "lng"
    t.string "lat_card"
    t.float "lat_deg"
    t.float "lat_min"
    t.float "lat_seg"
    t.string "lng_card"
    t.float "lng_deg"
    t.float "lng_min"
    t.float "lng_seg"
    t.index ["competicao_id"], name: "index_provas_on_competicao_id"
    t.index ["usuario_id"], name: "index_provas_on_usuario_id"
  end

  create_table "resultado_importados", force: :cascade do |t|
    t.integer "classif"
    t.string "ring"
    t.integer "year"
    t.string "p_sn"
    t.string "d_sn"
    t.string "e_sn"
    t.integer "idcriador"
    t.string "nomecriador"
    t.string "date"
    t.string "time"
    t.float "distance"
    t.float "veloc"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.float "points"
  end

  create_table "resultados", id: :serial, force: :cascade do |t|
    t.integer "prova_id"
    t.integer "pombo_id"
    t.datetime "dhrestimada", precision: nil
    t.datetime "dhroficial", precision: nil
    t.integer "posicao"
    t.float "pontos"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "usuario_id"
    t.float "dist_oficial"
    t.float "veloc_oficial"
    t.index ["pombo_id"], name: "index_resultados_on_pombo_id"
    t.index ["prova_id"], name: "index_resultados_on_prova_id"
    t.index ["usuario_id"], name: "index_resultados_on_usuario_id"
  end

  create_table "titulos", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.integer "ano"
    t.integer "pombo_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["pombo_id"], name: "index_titulos_on_pombo_id"
  end

  create_table "tratamentos", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "indicacao"
    t.integer "usuario_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["usuario_id"], name: "index_tratamentos_on_usuario_id"
  end

  create_table "usuarios", id: :serial, force: :cascade do |t|
    t.string "nome"
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "password_digest"
    t.string "remember_digest"
    t.boolean "admin"
    t.string "activation_digest"
    t.boolean "activated", default: false
    t.datetime "activated_at", precision: nil
    t.string "reset_digest"
    t.datetime "reset_sent_at", precision: nil
    t.integer "tipo_usuario"
    t.string "tel1"
    t.string "tel2"
    t.string "lat"
    t.string "lng"
    t.string "lingua"
    t.string "fuso"
    t.integer "estado_id"
    t.string "numero_cartao"
    t.string "nome_cartao"
    t.string "dtexpirado"
    t.string "bandeira_cartao"
    t.bigint "nacao_id"
    t.integer "passo_criacao"
    t.string "lat_card"
    t.float "lat_deg"
    t.float "lat_min"
    t.float "lat_seg"
    t.string "lng_card"
    t.float "lng_deg"
    t.float "lng_min"
    t.float "lng_seg"
    t.string "logradouro"
    t.string "nome_time"
    t.index ["email"], name: "index_usuarios_on_email", unique: true
    t.index ["nacao_id"], name: "index_usuarios_on_nacao_id"
  end

  add_foreign_key "clubes", "estados"
  add_foreign_key "clubes", "nacaos"
  add_foreign_key "competicaos", "usuarios"
  add_foreign_key "equipes", "usuarios"
  add_foreign_key "equipes_pombos", "equipes"
  add_foreign_key "equipes_pombos", "pombos"
  add_foreign_key "estados", "nacaos"
  add_foreign_key "planos", "usuarios"
  add_foreign_key "pombals", "usuarios"
  add_foreign_key "pombals_pombos", "pombals"
  add_foreign_key "pombals_pombos", "pombos"
  add_foreign_key "pombos", "cors"
  add_foreign_key "pombos", "usuarios"
  add_foreign_key "preparos", "usuarios"
  add_foreign_key "prova_preparos", "preparos"
  add_foreign_key "prova_preparos", "provas"
  add_foreign_key "prova_preparos", "usuarios"
  add_foreign_key "provas", "competicaos"
  add_foreign_key "provas", "usuarios"
  add_foreign_key "resultados", "usuarios"
  add_foreign_key "tratamentos", "usuarios"
  add_foreign_key "usuarios", "nacaos"
end
