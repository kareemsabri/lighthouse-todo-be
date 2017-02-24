module.exports = (sequelize) ->

  sequelize.models.List.belongsTo sequelize.models.User,
    foreignKey: "user_id"
    as: "user"

  sequelize.models.Todo.belongsTo sequelize.models.List,
    foreignKey: "list_id"
    as: "list"

  sequelize.models.List.hasMany sequelize.models.Todo,
    foreignKey: "list_id"
    as: "todos"